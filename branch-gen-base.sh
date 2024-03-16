#!/bin/sh

#Runs the setup script that asks you which optional stuff you want, autocomments itself once it finishes.
./setup.sh
exit

##setup variables, DO NOT MOVE THEM
directory=
branch_prefix=shiptest-mirror-
branch_suffix=
opt_confirm_run=0
opt_get_status=0
opt_open_vsc=0
opt_push=0
opt_make_pr=0

#Make sure no other open mirror PR exists
pr_exists=`gh pr list -R Sector-Echo-13-Team/Echo-SS13 -s open -S "Mirror \#" | grep -o -m 1 -c "Mirror #[[:digit:]]*"`

if [[ $pr_exists = 1 ]]
	then
	echo "Abort, other mirror PR already open."
fi

#Time for PR body generation
current_time_local=`date +"%T UTC%:::z"`
current_time_pr=`TZ="UTC": date +"%T($current_time_local) on %a %e, %b of, %Y UTC"`

#Current UTC date
current_date_utc=`TZ="UTC": date +"%d-%m-%Y"`

#Optional, ask for confirmation before running (decent idea if this is scheduled and you want to postpone until you're actually there to do stuff, also lets you preview the branch name)
if [[ $opt_confirm_run = 1 ]]
    then
    while true; do
        read -p "Create merge branch \"$branch_prefix$current_date_utc$branch_suffix\"? (Y/N): " answer
        case $answer in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Invalid.";;
        esac
    done
fi

#Change directory to where your fork of the echo repo is stored
cd "$directory"

#Optional, show current change status
if [[ $opt_get_status = 1 ]]
    then
	git status
fi

#Stash current changes so you don't lose anything you were doing
git stash

#Make branch with current time as part of the name based on up to date upstream master, push to your fork, pull from shiptest master 
git switch -C "$branch_prefix$current_date_utc$branch_suffix" upstream/master
git push -u origin
git pull https://github.com/shiptest-ss13/Shiptest master


#Optional, open VSC to the repo so you can do stuff
if [[ $opt_open_vsc = 1 ]]
    then
    code .
fi

#Optional, wait for an input to push
if [[ $opt_push = 1 ]]
    then
    read
    git push

    #Optional, PR generation
    if [[ $opt_make_pr = 1 ]]
        then
        latest_merged=`gh pr list -R Sector-Echo-13-Team/Echo-SS13 -s merged -S "Mirror \#" | grep -o -m 1 "Mirror #[[:digit:]]*" | head -1`
        latest_merged_num=`echo $latest_merged | grep -o "[[:digit:]]*"`
        new_pr_num=$((latest_merged_num+1))

        latest_merged_index=`gh pr list -R Sector-Echo-13-Team/Echo-SS13 -s merged -S "Mirror \#" | grep -m 1 "Mirror #[[:digit:]]*" | grep -o "[[:digit:]]*" | head -1`

        gh pr create -R Sector-Echo-13-Team/Echo-SS13 -t "Shiptest Mirror #$new_pr_num" -b "Partially automated Mirror PR script provided by [Ms-Mee](https://github.com/Ms-Mee/echo-mirror-script), run at $current_time_pr

### Previous Mirror: [Shiptest Mirror #$latest_merged_num](https://github.com/Sector-Echo-13-Team/Echo-SS13/pull/$latest_merged_index) (PR #$latest_merged_index)

- [ ] I affirm to have tested this mirror PR to a reasonable extent.
- [ ] I affirm the modular files affected by the changes in this mirror have been changed, or that none exist.
"
    fi
fi
