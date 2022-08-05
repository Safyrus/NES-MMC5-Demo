import sys
import re

# constants
CHAR_2_MAP = {
    "0": "000000", "1": "000001", "2": "000010", "3": "000011", "4": "000100", "5": "000101", "6": "000110", "7": "000111",
    "8": "001000", "9": "001001", "A": "001010", "B": "001011", "C": "001100", "D": "001101", "E": "001110", "F": "001111",
    "G": "010000", "H": "010001", "I": "010010", "J": "010011", "K": "010100", "L": "010101", "M": "010110", "N": "010111",
    "O": "011000", "P": "011001", "Q": "011010", "R": "011011", "S": "011100", "T": "011101", "U": "011110", "V": "011111",
    "W": "100000", "X": "100001", "Y": "100010", "Z": "100011", " ": "100100", ".": "100101", "!": "100110", "?": "000000",
    "*": "000000", "*": "000000", "*": "000000", "*": "000000", "*": "000000", "*": "000000", "*": "000000", "*": "000000",
    "*": "000000", "*": "000000", "*": "000000", "\n": "111010", "*": "000000", "*": "000000", "*": "000000", "*": "000000",
    "*": "000000", "*": "000000", "&": "111010", "SPD": "111011", "DICT": "111100", "LDICT": "111101", "EXT": "111110", "END": "111111"
}

# args
text_file_name = "dialog.txt"
output_file_name = "encode.bin"
dict_file_name = "dict.txt"
dict_file_name_asm = "dict.asm"


def print_word_asm(w, file):
    l = len(w)
    file.write("    .byte " + str(l) + " ; size\n")
    i = 0
    file.write("    .byte ")
    for c in w:
        val = int(CHAR_2_MAP[c], 2)
        s = str.format('0x{:02X}', val).split("x")[1].upper()
        file.write("$" + s)
        i += 1
        if i < l:
            file.write(", ")
    file.write("\n")

#
def create_dict(words, words_count):
    short_dict = [""]*64
    long_dict = [""]*(4096)

    l = len(words)
    for i in range(l):
        for j in range(i, l):
            if words_count[j] > words_count[i]:
                words_count[i], words_count[j] = words_count[j], words_count[i]
                words[i], words[j] = words[j], words[i]

    with open(dict_file_name_asm, "w") as asm:
        with open(dict_file_name, "w") as f:
            i = 0
            f.write("======== SHORT DICT ========\n")
            asm.write("dict:\n")
            for w in words:
                if i >= 4096+64:
                    break
                if i < 64:
                    if len(w) > 2:
                        short_dict[i] = w
                        f.write(w + "\n")
                        asm.write("    ; '" + w + "' at idx:" + hex(i) + " (appear " + str(words_count[i]) + " times)\n")
                        print_word_asm(w, asm)
                        if i == 63:
                            f.write("======== LONG DICT  ========\n")
                            asm.write("\nldict:\n")
                        i += 1
                else:
                    if len(w) > 3:
                        long_dict[i-64] = w
                        f.write(w + "\n")
                        if (i % 64) == 0:
                            idx = (i//64)-1
                            asm.write("    ldict_" + str(idx) + ":\n")
                        asm.write("    ; '" + w + "' at idx:" + hex(i) + " (appear " + str(words_count[i]) + " times)\n")
                        print_word_asm(w, asm)
                        i += 1
            if i < 63:
                asm.write("ldict: ; empty\n")

        n = (i//64)-1
        asm.write("\nldict_table_lo:\n")
        for i in range(n):
            asm.write("    .byte <ldict_" + str(i) + "\n")
        asm.write("ldict_table_hi:\n")
        for i in range(n):
            asm.write("    .byte >ldict_" + str(i) + "\n")

    return short_dict, long_dict

#
def write_encode_char(file, char):
    encode_char = int(CHAR_2_MAP[char], 2)
    file.write(encode_char.to_bytes(1, "big"))

# write value in little endian
def write_val(file, val, nb_byte=1):
    for _ in range(nb_byte):
        v = val%64
        file.write(v.to_bytes(1, "big"))
        val = val//64

def main():
    global text_file_name, output_file_name, dict_file_name, dict_file_name_asm, CHAR_2_MAP

    if len(sys.argv) > 1:
        text_file_name = sys.argv[1]
    if len(sys.argv) > 2:
        output_file_name = sys.argv[2]
    if len(sys.argv) > 3:
        dict_file_name = sys.argv[3]
    if len(sys.argv) > 4:
        dict_file_name_asm = sys.argv[4]

    #
    print("count words")
    words_str = []
    words_count = []
    f_in = open(text_file_name, "r")
    for line in f_in:
        line = line.split("\n")[0]
        words = re.split("\s|\&", line)
        for w in words:
            if w in words_str:
                idx = words_str.index(w)
                words_count[idx] += 1
            else:
                words_str.append(w)
                words_count.append(1)
    f_in.close()

    #
    print("create dict")
    short_dict, long_dict = create_dict(words_str, words_count)

    #
    print("encode")
    f_in = open(text_file_name, "r")
    f_out = open(output_file_name, "wb")
    for line in f_in:
        words = re.split("(\s|\&|\n)", line)
        seps = words[1::2]
        words = words[0::2]
        words.pop()

        i = 0
        for w in words:
            s = seps[i]
            if w in short_dict:
                write_encode_char(f_out, "DICT")
                write_val(f_out, short_dict.index(w))
                if s != " " and s != "\n":
                    write_encode_char(f_out, s)
            elif w in long_dict:
                write_encode_char(f_out, "LDICT")
                write_val(f_out, long_dict.index(w), nb_byte=2)
                if s != " " and s != "\n":
                    write_encode_char(f_out, s)
            else:
                for c in w:
                    if c in CHAR_2_MAP:
                        write_encode_char(f_out, c)
                if s != "\n":
                    write_encode_char(f_out, s)
            i += 1

        write_encode_char(f_out, "END")
    f_in.close()
    f_out.close()

if __name__ == '__main__':
    main()
