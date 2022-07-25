import sys
from time import sleep

MAP_2_CHAR = [
    "0", "1", "2", "3", "4", "5", "6", "7",
    "8", "9", "A", "B", "C", "D", "E", "F",
    "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V",
    "W", "X", "Y", "Z", " ", ".", "!", "?",
    "*", "*", "*", "*", "*", "*", "*", "*",
    "*", "*", "*", "*", "*", "*", "*", "*",
    "*", "*", "&", "^", "+", "#", "$", "%"
]

LDICT = 61
DICT = 60
NL = 58
END = 63

encode_filename = "text.chr"
char_filename = "cypher.txt"
dict_filename = "dict.txt"
pointer = 0
offset = 0
need_buf_update = False
no_end = False

def check_args():
    global encode_filename, char_filename, dict_filename, pointer, offset
    i = 1
    while len(sys.argv) > i:
        a = sys.argv[i]
        if a == "-p":
            i += 1
            a = sys.argv[i]
            pointer = int(a, base=16)
            i += 1
            a = sys.argv[i]
            offset = int(a, base=16)
        elif a == "-f":
            i += 1
            a = sys.argv[i]
            encode_filename = a
        elif a == "-d":
            i += 1
            a = sys.argv[i]
            dict_filename = a
        elif a == "-c":
            i += 1
            a = sys.argv[i]
            char_filename = a
        i += 1

def read_raw_data(dialog_data, pointer):
    raw_data = []
    for i in range(8):
        ptr = (pointer+i)%0x40000
        raw_data.append(dialog_data[ptr])
    return raw_data

def read_bit_from_left(val, offset):
    return (val >> (7-offset)) & 0x01

def next_char(buf, buf_ptr, pointer, offset, char_cypher):
    c = 1
    while True:
        tmp = buf[buf_ptr]
        c = (c << 1) + read_bit_from_left(tmp, offset)
        offset += 1
        if offset >= 8:
            offset = 0
            pointer += 1
            buf_ptr += 1
        for i in range(len(char_cypher)):
            if char_cypher[i] == c:
                return i, buf_ptr, pointer, offset

def main():
    global MAP_2_CHAR, LDICT, DICT, NL, END, MAP_2_CHAR, \
        encode_filename, char_filename, dict_filename, pointer, offset, need_buf_update, no_end

    #
    check_args()

    # read raw data
    with open(encode_filename, "rb") as f:
        dialog_data = f.read()

    # read char encoding
    char_cypher = [0]*64
    with open(char_filename, "r") as f:
        for line in f:
            num = int(line.split("(")[1].split(")")[0])
            val = int("1"+line.split(":")[1], base=2)
            char_cypher[num] = val

    # read dictionary
    with open(dict_filename, "r") as f:
        lines = f.read().splitlines()
    sdict = lines[1:65]
    ldict = lines[66:]


    once = False
    while no_end or not once:
        # init variables
        buf = read_raw_data(dialog_data, pointer)
        buf_ptr = 0
        char = 0

        # decode
        decoded_buffer = ""
        display_idx = 0
        remaining_char = 0
        while char != 0x3F or remaining_char > 0:
            if remaining_char <= 0:
                # read next char
                char, buf_ptr, pointer, offset = next_char(buf, buf_ptr, pointer, offset, char_cypher)

                # long dict
                if char == LDICT:
                    char, buf_ptr, pointer, offset = next_char(buf, buf_ptr, pointer, offset, char_cypher)
                    adr = char
                    char, buf_ptr, pointer, offset = next_char(buf, buf_ptr, pointer, offset, char_cypher)
                    adr += char << 6
                    decoded_buffer += ldict[adr] + " "
                    remaining_char += len(ldict[adr])+1
                # short dict
                elif char == DICT:
                    char, buf_ptr, pointer, offset = next_char(buf, buf_ptr, pointer, offset, char_cypher)
                    adr = char
                    decoded_buffer += sdict[adr] + " "
                    remaining_char += len(sdict[adr])+1
                # new line
                elif char == NL:
                    decoded_buffer += "\n"
                    remaining_char += 1
                # end
                elif char == END:
                    pass
                # normal char
                else:
                    decoded_buffer += MAP_2_CHAR[char]
                    remaining_char += 1

            # do we need to read more data
            if buf_ptr >= len(buf)//2:
                buf_ptr = 0
                need_buf_update = True

            # 'simulate' NMI
            sleep(0.05)
            if need_buf_update:
                need_buf_update = False
                buf = read_raw_data(dialog_data, pointer)
            if remaining_char > 0:
                print(decoded_buffer[display_idx], end="", flush=True)
                display_idx += 1
                remaining_char -= 1

        print("\n")
        once = True

if __name__ == '__main__':
    main()
