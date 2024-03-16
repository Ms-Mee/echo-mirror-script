#!/bin/sh

cp -rf "./branch-gen-base.sh" "./branch-gen.sh"

read -p "Absolute or relative path to your echo directory (examples: C:/Users/user/Documents/SS13\ repos/Echo\ 13/Shiptest, ../../SS13\ repos/Echo\ 13/Shiptest): " new_value
new_value="'$new_value'"
sed -i "8c directory=$new_value" "branch-gen.sh"

while true; do
	read -p "Change branch prefix? (default: shiptest-mirror) (Y/N): " answer
	case $answer in
		[Yy]* )
            read -p "New branch prefix: " new_value
            sed -i "9s/=.*/=$new_value/" "branch-gen.sh"
            break;;
		[Nn]* ) break;;
		* ) echo "Invalid.";;
	esac
done

while true; do
	read -p "Change branch suffix? (Y/N): " answer
	case $answer in
		[Yy]* )
            read -p "New branch suffix: " new_value
            sed -i "10s/=.*/=$new_value/" "branch-gen.sh"
            break;;
		[Nn]* ) break;;
		* ) echo "Invalid.";;
	esac
done

while true; do
	read -p "Confirm before running? (Y/N): " answer
	case $answer in
		[Yy]* ) 
            sed -i "11s/0/1/" "branch-gen.sh"
            break;;
		[Nn]* ) 
            sed -i "11s/1/0/" "branch-gen.sh"
            break;;
		* ) echo "Invalid.";;
	esac
done

while true; do
	read -p "Check current branch status before stashing? (Y/N): " answer
	case $answer in
		[Yy]* ) 
            sed -i "12s/0/1/" "branch-gen.sh"
            break;;
		[Nn]* ) 
            sed -i "12s/1/0/" "branch-gen.sh"
            break;;
		* ) echo "Invalid.";;
	esac
done

while true; do
	read -p "Open VSC to resolve conflicts? (Y/N): " answer
	case $answer in
		[Yy]* ) 
            sed -i "13s/0/1/" "branch-gen.sh"
            break;;
		[Nn]* ) 
            sed -i "13s/1/0/" "branch-gen.sh"
            break;;
		* ) echo "Invalid.";;
	esac
done

while true; do
	read -p "Wait on the console and then push changes after you enter anything(required for auto PR)? (Y/N): " answer
	case $answer in
		[Yy]* ) 
            sed -i "14s/0/1/" "branch-gen.sh"
            break;;
		[Nn]* ) 
            sed -i "14s/1/0/" "branch-gen.sh"
            sed -i "15s/1/0/" "branch-gen.sh"
            break;;
		* ) echo "Invalid.";;
	esac
done

if [[ $answer = "Y" || $answer = "y" ]]
    then
    while true; do
        read -p "Automatically make PRs(requires github CLI)? (Y/N): " answer
        case $answer in
            [Yy]* ) 
                sed -i "15s/0/1/" "branch-gen.sh"
                while true; do
                    read -p "Login to github cli now? (Y/N): " login
                    case $login in
                        [Yy]* )
                            echo y | gh auth login -w -p https
                            break;;
                        [Nn]* )
                            break;;
                        * ) echo "Invalid.";;
                    esac
                done
                break;;
            [Nn]* ) 
                sed -i "15s/1/0/" "branch-gen.sh"
                break;;
            * ) echo "Invalid.";;
        esac
    done
fi

echo "Setup done, rerun the branch-gen script if this was your first time running it."

sed -i "4c #./setup.sh/" "branch-gen.sh"
sed -i "5c #exit" "branch-gen.sh"

read
