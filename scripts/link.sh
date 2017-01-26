
IGNORE=(Readme.md scripts config nvim)
DIR="$( cd -P "$( dirname "../${BASH_SOURCE[0]}" )" && pwd )"

ignored() {
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 4
}

printf "\033[0;34mCreating Symlinks:\033[0m\n"

ln -s $DIR/nvim/* $HOME/.config/nvim/

for file in $(ls ${DIR}); do
  ignored $file "${IGNORE[@]}"

  if [ $? -eq 0 ]; then
    continue
  fi
  printf "$DIR/$file => ~/.$file\n"
  rm -r $HOME/.$file &> /dev/null
  ln -s $DIR/$file ~/.$file
done

# Creating default folders
printf "\033[0;34mCreating Default Folders\033[0m\n~/projects\n~/vcode\n~/test_cases\n~/go\n"
mkdir $HOME/{projects,vcode,test_cases,go} &> /dev/null
