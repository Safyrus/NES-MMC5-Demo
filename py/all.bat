if "%1"=="" goto noarg

:arg
    python encode.py %1
    python huffman_encode.py
    goto end

:noarg
    python encode.py
    python huffman_encode.py

:end
    del encode.bin