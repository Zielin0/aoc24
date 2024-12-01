module aoc;

import std::io;
import std::io::os;
import std::os::posix;
import libc;

const String TEMPLATE =
`module day%02d;

import std::io;
import utils;

fn String! get_file(bool input)
{
    Path cwd = path::new_cwd()!;
    String[] dirs = cwd.path_string.split("/");
    String prefix = ".";
    if (dirs[dirs.len-1] != "day%02d") {
        prefix = "day%02d";
    }
    if (input) {
        return string::tformat("%%s/input.txt", prefix);
    } else {
        return string::tformat("%%s/sample.txt", prefix);
    }
}

fn bool part1(String data)
{
    io::printn("Part 1 result:");
    return true;
}

fn bool part2(String data)
{
    io::printn("Part 2 result:");
    return true;
}

fn int main()
{
    String! file = get_file(false);
    if (catch excuse = file) {
        io::printn("ERROR: Failed to get the input file path");
        return 1;
    }
    String! data = utils::read_file_to_string(file);
    if (catch excuse = data) {
        io::printfn("ERROR: Failed to read '%%s': %%s", file, excuse);
        return 1;
    }
    if (!part1(data)) {
        io::printn("ERROR: Failed to execute part1");
        return 1;
    }
    if (!part2(data)) {
        io::printn("ERROR: Failed to execute part2");
        return 1;
    }
    return 0;
}
`;


fn bool create_day(int day)
{
    String path = string::tformat("day%02d/", day);
    if (posix::mkdir((ZString)path, 0o700)) {
        io::printfn("ERROR: Failed to create '%s'", path);
        return false;
    }

    String file_path = string::tformat("%smain.c3", path);
    File! file = file::open(file_path, "w");
    defer (void)file.close();
    if (catch excuse = file) {
        io::printfn("ERROR: Failed opening '%s': %s", file_path, excuse);
        return false;
    }

    String content = string::tformat(TEMPLATE, day, day, day);
    if (catch excuse = file.write(content)) {
        io::printfn("ERROR: Failed to write to '%s': %s", file_path, excuse);
        return false;
    }

    return true;
}

fn bool run_a_day(int day)
{
    const String UTILS_SOURCE = "utils.c3";
    String day_source = string::tformat("./day%02d/main.c3", day);
    String day_output = string::tformat("./day%02d/main", day);

    String build_command =
        string::tformat("c3c compile %s %s -o %s", day_source, UTILS_SOURCE, day_output);

    io::printfn("+ %s", build_command);
    int ret = libc::system((ZString)build_command);
    if (ret != 0) {
        io::printfn("ERROR: Failed building day %d", day);
        return false;
    }

    io::printfn("+ %s", day_output);
    ret = libc::system((ZString)day_output);

    return ret == 0;
}

fn bool run_all_days()
{
    for (int i = 0; i < 25; i++) {
        int day = i+1;
        io::printn("-------- Day %d --------");
        String day_dir = string::tformat("./day%02d/", day);
        Path! day_path = path::new(day_dir);
        if (catch excuse = day_path) {
            io::printfn("ERROR: Failed to create new path '%s': %s", day_dir, excuse);
            return false;
        }
        if (!path::exists(day_path)) {
            continue;
        }
        if (!run_a_day(day)) {
            return false;
        }
    }
    return true;
}

fn void print_usage(String program_name)
{
    const String TAB = "\x20\x20";

    io::printn("ERROR: No command provided");
    io::printfn("Usage: %s <command> [<args>]", program_name);
    io::printn();
    io::printn("Commands:");
    io::printfn("%snew <day>        - Create a new day directory with a c3 source file", TAB);
    io::printfn("%srun <day>|all    - Build and Run a day, or Build and Run all days", TAB);
    io::printn();
}

fn int main(String[] args)
{
    if (args.len == 1) {
        print_usage(args[0]);
        return 1;
    }

    if (args[1] == "new") {
        if (args.len < 3) {
            io::printn("ERROR: No day number provided");
            return 1;
        }
        int day_num = libc::atoi(args[2]);
        if (day_num == 0) {
            io::printn("ERROR: Cannot create 0th day");
            return 1;
        }
        assert(day_num > 0 && day_num <= 25);
        if (!create_day(day_num)) {
            io::printfn("ERROR: Failed to create day %d", day_num);
            return 1;
        }
        io::printfn("Created day %d successfully", day_num);
        return 0;
    }

    if (args[1] == "run") {
        if (args.len < 3) {
            io::printn("ERROR: No day number provided");
            return 1;
        }
        String arg = args[2];
        if (arg == "all") {
            if (!run_all_days()) {
                io::printn("ERROR: Failed to run all days");
                return 1;
            }
            return 0;
        }
        int day_num = libc::atoi(arg);
        if (day_num == 0) {
            io::printn("ERROR: Cannot run 0th day");
            return 1;
        }
        assert(day_num > 0 && day_num <= 25);
        if (!run_a_day(day_num)) {
            io::printfn("ERROR: Failed to run day %d", day_num);
            return 1;
        }
        return 0;
    }

    io::printfn("ERROR: Invalid command: %s", args[1]);

    return 1;
}

