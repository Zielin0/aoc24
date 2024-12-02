module day02;

import std::io;
import std::collections::list;
import std::sort;
import std::math;
import utils;

fn String! get_file(bool input)
{
    Path cwd = path::new_cwd()!;
    String[] dirs = cwd.path_string.split("/");
    String prefix = ".";
    if (dirs[dirs.len-1] != "day02") {
        prefix = "day02";
    }
    if (input) {
        return string::tformat("%s/input.txt", prefix);
    } else {
        return string::tformat("%s/sample.txt", prefix);
    }
}

fn bool compare_lists(List(<int>) a, List(<int>) b)
{
    assert(a.size == b.size);
    bool result = true;
    for (usz i = 0; i < a.size; i++) {
        if (a[i] != b[i]) {
            result = false;
            break;
        }
    }
    return result;
}

fn bool compare_ascending(List(<int>) list)
{
    List(<int>) temp;
    foreach (it : list) {
        temp.push(it);
    }
    sort::quicksort(temp, fn int (int a, int b) => (int)(a - b));
    return compare_lists(list, temp);
}

fn bool compare_descending(List(<int>) list)
{
    List(<int>) temp;
    foreach (it : list) {
        temp.push(it);
    }
    sort::quicksort(temp, fn int (int a, int b) => (int)(b - a));
    return compare_lists(list, temp);
}

fn bool check_distances(List(<int>) list)
{
    int min_distance = 1;
    int max_distance = 3;
    for (usz i = 0; i < list.size-1; i++) {
        int difference = math::abs(list[i]-list[i+1]);
        if (difference > max_distance || difference < min_distance) {
            return false;
        }
    }
    return true;
}

fn void! part1(String data)
{
    String[] reports = data.split("\n");
    int result = 0;
    foreach (report : reports) {
        if (report == "") break;
        String[] levels_s = report.split(" ");
        List(<int>) levels;
        for (usz i = 0; i < levels_s.len; i++) {
            levels.push(levels_s[i].to_int()!);
        }
        bool ascending = compare_ascending(levels);
        bool descending = compare_descending(levels);
        bool asc_or_desc = ascending || descending;
        bool distances = check_distances(levels);
        if (distances && asc_or_desc) {
            result++;
        }
    }
    io::printfn("Part 1 result: %d", result);
}

fn void! part2(String data)
{
    String[] reports = data.split("\n");
    int result = 0;
    foreach (report : reports) {
        if (report == "") break;
        String[] levels_s = report.split(" ");
        List(<int>) levels;
        for (usz i = 0; i < levels_s.len; i++) {
            levels.push(levels_s[i].to_int()!);
        }
        int counter = -1;
        bool check_all = false;
        while (counter < levels.size) {
            List(<int>) levels_temp;
            foreach (it : levels) {
                levels_temp.push(it);
            }
            if (counter != -1) {
                levels_temp.remove_at(counter);
            }
            bool ascending = compare_ascending(levels_temp);
            bool descending = compare_descending(levels_temp);
            bool asc_or_desc = ascending || descending;
            bool distances = check_distances(levels_temp);
            check_all = check_all || (asc_or_desc && distances);
            counter++;
        }
        if (check_all) {
            result++;
        }
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
        io::printfn("ERROR: Failed to execute part1 %s: ", excuse);
        return 1;
    }
    if (catch excuse = part2(data)) {
        io::printfn("ERROR: Failed to execute part2: %s: ", excuse);
        return 1;
    }
    return 0;
}
