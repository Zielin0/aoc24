module day03;

import std::io;
import utils;

fn String! get_file(bool input)
{
    Path cwd = path::new_cwd()!;
    String[] dirs = cwd.path_string.split("/");
    String prefix = ".";
    if (dirs[dirs.len-1] != "day03") {
        prefix = "day03";
    }
    if (input) {
        return string::tformat("%s/input.txt", prefix);
    } else {
        return string::tformat("%s/sample.txt", prefix);
    }
}

fn int! get_mul(String* data)
{
    String temp_data = *data;
    if (!temp_data.contains("mul(")) {
        return -1;
    }
    usz idx = temp_data.index_of("mul(")!;
    temp_data = (*data)[idx+4..data.len-1];
    usz first_idx = temp_data.index_of(",")!;
    int! first_num = temp_data[0..first_idx-1].to_int();
    if (catch excuse = first_num) {
        idx = temp_data.index_of("mul(")!;
        temp_data = temp_data[idx..temp_data.len-1];
        *data = temp_data;
        return 0;
    }
    temp_data = temp_data[first_idx+1..temp_data.len-1];
    usz! second_idx = temp_data.index_of(")");
    if (catch excuse = second_idx) {
        return 0;
    }
    int! second_num = temp_data[0..second_idx-1].to_int();
    if (catch excuse = second_num) {
        idx = temp_data.index_of("mul(")!;
        temp_data = temp_data[idx..temp_data.len-1];
        *data = temp_data;
        return 0;
    }
    temp_data = temp_data[second_idx+1..temp_data.len-1];
    *data = temp_data;
    return first_num*second_num;
}

fn void! part1(String data)
{
    int result = 0;
    int mul = get_mul(&data)!;
    while (mul != -1) {
        result += mul;
        mul = get_mul(&data)!;
    }

    io::printfn("Part 1 result: %d", result);
}

fn void! part2(String data)
{
    // can't get it working, am i rotated or something?
    // i'll try tomorrow...
    io::printn("Part 2 result: N/A");
}

fn int main()
{
    String! file = get_file(true);
    if (catch excuse = file) {
        io::printn("ERROR: Failed to get the input file path");
        return 1;
    }
    String! data = utils::read_file_to_string(file);
    if (catch excuse = data) {
        io::printfn("ERROR: Failed to read '%s': %s", file, excuse);
        return 1;
    }
    if (catch excuse = part1(data)) {
        io::printfn("ERROR: Failed to execute part1: %s", excuse);
        return 1;
    }
    if (catch excuse = part2(data)) {
        io::printfn("ERROR: Failed to execute part2: %s", excuse);
        return 1;
    }
    return 0;
}
