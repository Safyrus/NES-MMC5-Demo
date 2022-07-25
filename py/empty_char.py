import sys

output_filename = "empty.chr"
size = 0x40000 # 256K

if len(sys.argv) > 1:
    size = int(sys.argv[1])

with open(output_filename, "wb") as f:
    f.write(bytes(size))
