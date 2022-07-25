import sys
import huffman

MAP_2_CHAR = [
    "0", "1", "2", "3", "4", "5", "6", "7",
    "8", "9", "A", "B", "C", "D", "E", "F",
    "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V",
    "W", "X", "Y", "Z", "_", ".", "!", "?",
    "*", "*", "*", "*", "*", "*", "*", "*",
    "*", "*", "*", "*", "*", "*", "*", "*",
    "*", "*", "&", "^", "+", "#", "$", "%"
]

def main():
    global MAP_2_CHAR

    encode_file_name = "encode.bin"
    if len(sys.argv) > 1:
        encode_file_name = sys.argv[1]
    out_file_name = "text.chr"
    if len(sys.argv) > 2:
        out_file_name = sys.argv[2]
    out_decoding = "cypher.txt"
    if len(sys.argv) > 3:
        out_decoding = sys.argv[3]
    out_pointer = "pointer.txt"
    if len(sys.argv) > 3:
        out_decoding = sys.argv[4]

    proba_char = []
    proba_count = []

    #
    f = open(encode_file_name, "rb")
    txt = []
    for line in f:
        for char in line:
            if char in proba_char:
                idx = proba_char.index(char)
                proba_count[idx] += 1
                txt.append(char)
            else:
                proba_char.append(char)
                proba_count.append(1)
                txt.append(char)
    f.close()

    #
    proba = []
    for i in range(len(proba_count)):
        proba.append((proba_char[i], proba_count[i]))

    #
    huff_res = huffman.codebook(proba)

    #
    f = open(out_decoding, "w")
    for k,v in huff_res.items():
        idx = proba_char.index(k)
        c = MAP_2_CHAR[k]
        print(f"{c}({str(k)}): count {str(proba_count[idx])} times, encode as {str(v)}")
        f.write(c + "(" + str(k) + "):" + str(v) + "\n")
    f.close()

    #
    f = open(out_pointer, "w")
    f.write("0:0\n")
    huff_txt = ""
    last_c = 0
    for c in txt:
        if last_c == 63:
            l = len(huff_txt)
            adr = l//8
            offset = l%8
            f.write(hex(adr) + ":" + str(offset) + "\n")
        huff_txt += huff_res[c]
        last_c = c
    f.close()

    #
    f = open(out_file_name, "wb")
    #
    i = 0
    hex_str = ""
    while i < len(huff_txt)//8:
        val = int(huff_txt[i*8:i*8+8], 2)
        byte = val.to_bytes(1, byteorder='big')
        hex_str += hex(val) + " "
        f.write(byte)
        i += 1
    val = huff_txt[i*8:]
    if val != "":
        byte = int(val, 2).to_bytes(2, byteorder='big')
        f.write(byte)

    #
    i = (len(huff_txt)//8)
    if len(huff_txt) % 8 > 0:
        i += 2
    while i < 0x40000:
        f.write(bytes(1))
        i += 1

    #
    f.close()

if __name__ == '__main__':
    main()
