function lscolors() {
  for i in {0..255}; do
    printf "\e[48;05;%dm%-10d\n" ${i} ${i}
  done | column -c 120 -s ''; echo -e "\e[m"
}
