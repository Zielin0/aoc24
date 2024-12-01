module utils;

import std::io;

fn String! read_file_to_string(String file_path)
{
    File file = file::open(file_path, "r")!;
    defer (void)file.close();

    String buffer;
    file.read(buffer)!;

    return buffer;
}

