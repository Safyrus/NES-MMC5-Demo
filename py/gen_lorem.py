import sys
import lorem

def main():
    out_file_name = "dialog.txt"
    if len(sys.argv) > 1:
        encode_file_name = sys.argv[1]

    SENTENCE_NUMBER = 32*1024
    MAX_SENTENCE_LEN = 64

    with open(out_file_name, "w") as f:
        for i in range(SENTENCE_NUMBER):
            sentence = lorem.sentence().upper().split(".")[0]
            while len(sentence) > MAX_SENTENCE_LEN:
                s = sentence[0:MAX_SENTENCE_LEN]
                sentence = sentence[MAX_SENTENCE_LEN:]
                f.write(s + "\n")
            f.write(sentence + " .\n")

if __name__ == '__main__':
    main()
