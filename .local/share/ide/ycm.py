import os
import ycm_core

default_flags = [
    # predefined
    '-Wall',
    '-Wextra',
    '-fexceptions',
    '-std=c++11',
    '-x',
    'c++',
    '-isystem', '/usr/include',
    '-isystem', '/usr/local/include',
]

compilation_database_folder = os.getcwd() + '/build/'


def get_database():
    if os.path.isdir(compilation_database_folder):
        return ycm_core.CompilationDatabase(compilation_database_folder)
    return None


def make_relative_paths_in_flags_absolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


# pylint: disable=C0103
def FlagsForFile(filename):
    """This is the old entry point for YCM. Its interface is fixed.
    Args:
      filename: (String) Path to source file being edited.
    Returns:
      (Dictionary)
        'flags': (List of Strings) Command line flags.
        'do_cache': (Boolean) True if the result should be cached.
    """
    return Settings(filename=filename)


# pylint: disable=C0103
def Settings(**kwargs):
    filename = kwargs['filename']
    database = get_database()
    if database:
        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a "list-like" StringVec object
        compilation_info = database.GetCompilationInfoForFile(filename)
        final_flags = make_relative_paths_in_flags_absolute(
                compilation_info.compiler_flags_,
                compilation_info.compiler_working_dir_)
    else:
        relative_to = os.path.dirname(os.path.abspath(filename))
        final_flags = make_relative_paths_in_flags_absolute(default_flags, relative_to)

    return {
        'flags': final_flags,
        'do_cache': True
    }
