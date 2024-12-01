module utils;

import std::io;

fn String! read_file_to_string(String file_path)
{
    File file = file::open(file_path, "r")!;
    defer (void)file.close();

    char[] buffer = mem::new_array(char, file::get_size(file_path)!);
    file.read(buffer)!;

    return (String)buffer;
}

