#!/bin/bash

# requirements: dmenu, xdg-open/$BROWSER , xclip (optional), libnotify (optional)

# TODO: Make folder in the end of the mark in dmenu (and maybe add urls)
# TODO: Write "usage" message
# TODO: JSON export/import, some check_command for jq
# TODO: Check for any way to open browser at startup
# TODO: Add notifications
# TODO: Add ESC support when add mark

########################
# # # # SETTINGS # # # #
########################

bookmarks_dir="$XDG_DATA_HOME/bookmarks"
message_type="notify" # values: notify stdout none

#########################
# # # # # UTILS # # # # #
#########################

INFO_MSG="INFO"
ERROR_MSG="ERROR"
INVALID_ARG="Invalid argument"

declare folders_str marks_str
declare -a folders_arr marks_arr
declare return_value return_value_2

init() {
    # create bookmarks dir
    [ ! -d "$bookmarks_dir" ] && mkdir -p "$bookmarks_dir"

    # load folders
    folders_str=$(ls -p "$bookmarks_dir" | grep -v /)
    readarray -t folders_arr <<< "$folders_str"

    # load marks
    local folder idx fmarks_str fmarks_arr
    for folder in "${folders_arr[@]}" ; do
        fmarks_str="$(cut -d $'\t' -f1 "$bookmarks_dir/$folder")"
        readarray -t fmarks_arr <<< "$fmarks_str"

        for idx in "${!fmarks_arr[@]}" ; do
            folder_marks[$idx]="[$folder] ${fmarks_arr[$idx]}"
            marks_str="${marks_str}\n${folder_marks[$idx]}"
        done
        marks_arr+=("${folder_marks[@]}")
    done
    marks_str="${marks_str:2}" # remove newline in beginning
}

show_message() {
	case $message_type in
		notify) notify-send "$1" "$2" ;;
		stdout) echo -e "$1\n$2" ;;
	esac
}

exit_if_empty() { [ -z "$1" ] && exit 1 ; }

contains_element () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

select_folder() {
    pushd "$bookmarks_dir" 1>/dev/null || exit 1

    [ ${#folders_arr} -eq 0 ] && show_message "$INFO_MSG" "No folders" && exit 0

	local folder=$(echo "${folders_str}" | dmenu -i -p "Choose folder:")
    exit_if_empty "$folder"

    contains_element "$folder" "${folders_arr[@]}"
	[ "$?" -ne 0 ] && show_message "$ERROR_MSG" "No such folder" && exit 1
	return_value="$folder"
    popd 1>/dev/null || exit 1
}

select_mark() {
    pushd "$bookmarks_dir" 1>/dev/null || exit 1
    local mark folder

	mark=$(echo -e "${marks_str[@]}" | dmenu -i -l 10 -p "Choose mark:")
    exit_if_empty "$mark"

	contains_element "$mark" "${marks_arr[@]}"
	[ "$?" -ne  "0" ] && show_message "$ERROR_MSG" "Incorrect mark" && exit 1

    folder="$(echo "$mark" | sed -n "s/\[\(.\+\)\].\+/\1/p")"
    mark="$(echo "$mark" | sed -n "s/\[.\+\]\s\(.\+\)/\1/p")"

    return_value="$(sed -n "/^$mark\t/p" "$bookmarks_dir/$folder")"
    return_value_2="$folder"

    popd 1>/dev/null || exit 1
}

is_prefixed_uri() {
    [[ "$1" =~ ^http://.* ]] || [[ "$1" =~ ^https://.* ]]
}

########################
# # # # COMMANDS # # # #
########################

new_mark() {
	select_folder
	local folder="$return_value"

	local title=$(dmenu -p "Enter title:" <&-)
    exit_if_empty "$title" # TODO: accept empty, but handle ESC button
	local uri=$(dmenu -p "Enter address:" <&-)
    exit_if_empty "$uri"

    if [ -z "$title" ]; then
        answer=$(echo "Yes\nNo" | dmenu -p "Use address as name?")
        [ "$answer" = "No" ] || [ -z "$answer" ] && exit 1
    fi

    echo -e "$title\t$uri" >> "$bookmarks_dir/$folder"
}

delete_mark() {
    select_mark
	local mark="$return_value"
    local folder="$return_value_2"
    sed -i "/^${mark//\//\/\/}/d" "$bookmarks_dir/$folder"
}

new_folder() {
    pushd "$bookmarks_dir" 1>/dev/null || exit 1
	local folder="$(dmenu -p "Enter folder name:" <&-)"
    exit_if_empty "$folder"
    touch "$folder"
    popd 1>/dev/null || exit 1
}

delete_folder() {
    pushd "$bookmarks_dir" 1>/dev/null || exit 1
	select_folder
    local folder="$return_value"
    rm "$folder"
    popd 1>/dev/null || exit 1
}

open_url() {
    select_mark
	local mark="$return_value"

    local uri="$(echo "$mark" | cut -d $'\t' -f2)"
    is_prefixed_uri "$uri"
	[ "$?" -ne "0" ] && uri="https://$uri"
	setsid xdg-open "$uri" &>/dev/null &
}

copy_uri() {
    select_mark
	local mark="$return_value"

    local uri="$(echo "$mark" | cut -d $'\t' -f2)"
	echo "$uri" | xclip -sel clip && show_message "Copied to clipboard" "$uri"
	echo "$uri" | xclip -sel prim && show_message "Copied to primary" "$uri"
}

edit_mark() {
    select_mark
	local mark="$return_value"
    local folder="$return_value_2"

    local title="$(echo "$mark" | cut -d $'\t' -f1)"
    local uri="$(echo "$mark" | cut -d $'\t' -f2)"

    local new_title="$(echo "$title" | dmenu -p "Edit title (Shift-Enter to submit):")"
	[ -z "$new_title" ] && exit 1
	local new_uri="$(echo "$uri" | dmenu -p "Edit address (Shift-Enter to submit):")"
	[ -z "$new_uri" ] && exit 1

    sed -i "s,^$mark$,$new_title\t$new_uri," "$bookmarks_dir/$folder"
}

move_mark() {
    select_mark
	local mark="$return_value"
    local folder="$return_value_2"

	select_folder "Choose new folder"
	local new_folder="$return_value"

    sed -i "/^$mark$/d" "$bookmarks_dir/$folder"
    echo -e "$mark" >> "$bookmarks_dir/$new_folder"
}

edit_folder() {
    pushd "$bookmarks_dir" 1>/dev/null || exit 1
	select_folder
    local folder="$return_value"

    local new_folder="$(echo "$folder" | dmenu -p "Edit folder (Shift-Enter to submit):")"
	[ -z "$new_folder" ] && exit 1
    [ -f "$new_folder" ] && \
        show_message "$ERROR_MSG" "Folder with this name already exists" && \
        exit 1

    mv "$folder" "$new_folder"
    popd 1>/dev/null || exit 1
}

show_help() {
    echo "Usage: ${0##*/} [command]"
    echo "Interactive mode enabled when no command given"
    echo
    echo 'Commands:'
    echo '    addmark - add bookmark'
    echo '    addfolder - add folder'
    echo '    editmark - edit bookmark'
    echo '    editfolder - edit folder'
    echo '    delmark - delete bookmark'
    echo '    delfolder - delete folder'
    echo '    open - open bookmark'
    echo '    copy - copy URI'
    echo '    move - move bookmark'
}

handler() {
	case $1 in
		add*mark)    new_mark ;;
		add*folder)  new_folder ;;
		del*mark)    delete_mark ;;
		del*folder)  delete_folder ;;
		edit*mark)   edit_mark ;;
        edit*folder) edit_folder ;;
		open*) open_url ;;
		copy*) copy_uri ;;
		move*) move_mark ;;
        help)  show_help ;;
		*) echo -e "$INVALID_ARG '$1'" && exit 1 ;;
	esac
}

commands="add bookmark
add folder
edit bookmark
edit folder
delete bookmark
delete folder
open bookmark
copy URI
move bookmark"

#######################
# # # # # RUN # # # # #
#######################

init

if [ -z "$1" ]; then
	action=$(echo -e -n "$commands" | dmenu -i -p "Choose action")
	handler "$action"
else
    handler "$1"
fi
