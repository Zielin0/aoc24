module day01;

import std::io;
import std::collections::list;
import std::math;
import utils;

fn String! get_file(bool input)
{
    Path cwd = path::new_cwd()!;
    String[] dirs = cwd.path_string.split("/");
    String prefix = ".";
    if (dirs[dirs.len-1] != "day01") {
        prefix = "day01";
    }
    if (input) {
        return string::tformat("%s/input.txt", prefix);
    } else {
        return string::tformat("%s/sample.txt", prefix);
    }
}

fn usz! min_index_list(List(<int>) list)
{
    int item = int.max;
    for (int i = 0; i < list.size; i++) {
        if (list[i] < item) {
            item = list[i];
        }
    }

    return list.index_of(item)!;
}

fn usz! times_in_list(List(<int>) list, int num)
{
    List(<int>) temp;

    foreach (it : list) {
        temp.push(it);
    }

    usz times = 0;
    while (try temp.index_of(num)) {
        if (catch temp.remove_at(temp.index_of(num))) {
            break;
        }
        times++;
    }

    return times;
}

fn void! part1(String data)
{
    String[] lines = data.split("\n");
    List(<int>) left;
    List(<int>) right;
    int result = 0;
    foreach (line : lines) {
        if (line == "") break;
        String[] sides = line.split("   ");

        int left_int = sides[0].to_int()!;
        int right_int = sides[1].to_int()!;

        left.push(left_int);
        right.push(right_int);
    }

    while (!left.is_empty() && !right.is_empty()) {
        usz min_idx_left = min_index_list(left)!;
        usz min_idx_right = min_index_list(right)!;

        int min_left = left[min_idx_left];
        int min_right = right[min_idx_right];

        int difference = math::abs(min_left - min_right);
        result += difference;

        left.remove_at(min_idx_left);
        right.remove_at(min_idx_right);
    }

    io::printfn("Part 1 result: %d", result);
}

fn void! part2(String data)
{
    String[] lines = data.split("\n");
    List(<int>) left;
    List(<int>) right;
    int result = 0;
    foreach (line : lines) {
        if (line == "") break;
        String[] sides = line.split("   ");

        int left_int = sides[0].to_int()!;
        int right_int = sides[1].to_int()!;

        left.push(left_int);
        right.push(right_int);
    }

    foreach (item : left) {
        usz times = times_in_list(right, item)!;
        result += (item*(int)times);
    }

    io::printfn("Part 2 result: %d", result);
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

