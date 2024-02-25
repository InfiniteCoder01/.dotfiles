function gC --wraps=git --description 'git add, commit and push'
 git add . && git commit $argv && git push; 
end
