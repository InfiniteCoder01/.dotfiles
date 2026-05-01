import sys

$CARGO_HOME = $XDG_DATA_HOME + "/cargo"
$RUSTUP_HOME = $XDG_DATA_HOME + "/rustup"
$WAKATIME_HOME = $XDG_CONFIG_HOME + "/wakatime"
# $MAVEN_OPTS = "-Dmaven.repo.local=" + $XDG_DATA_HOME + "/maven/repository"
$CUDA_CACHE_PATH = $XDG_CACHE_HOME + "/nv"
$PATH.insert(0, "/home/infinitecoder/.dotfiles/xonsh/venv/bin")
$PATH.append($CARGO_HOME + "/bin")

from xonsh.tools import register_custom_style
register_custom_style("fixed", {
    "BACKGROUND_INTENSE_BLACK": "#000000",
}, base="default")
$XONSH_COLOR_STYLE="fixed"

$EDITOR = "hx"
$VISUAL = $EDITOR
$SHELL = "xonsh" # Fix nix develop

$fzf_history_binding = "c-r"
$fzf_ssh_binding = "c-s"
$fzf_file_binding = "c-t"
$fzf_dir_binding = "c-g"

xontrib load vox
xontrib load fzf-completions
# xontrib load readable-traceback

execx($(starship init xonsh))
execx($(zoxide init xonsh), "exec", __xonsh__.ctx, filename="zoxide")

$TITLE = "{cwd_base}"

def _y(args):
    tmp = $(mktemp -t "yazi-cwd.XXXXXX")
    args.append(f"--cwd-file={tmp}")
    $[yazi @(args)]
    with open(tmp) as f:
        cwd = f.read().strip()
    if cwd and cwd != $PWD:
        cd @(cwd)
    rm -f -- @(tmp)

aliases["y"] = _y
aliases["flake-new"] = "wget https://gist.githubusercontent.com/InfiniteCoder01/e3b8f14405114a7cff1618d807612545/raw/flake.nix -O flake.nix"

aliases["x"] = "eza --icons always"
aliases["xa"] = "eza --icons always --all"
aliases["xl"] = "eza --icons always --long"
aliases["xla"] = "eza --icons always --long --all"
aliases["xt"] = "eza --icons always --tree"
aliases["xta"] = "eza --icons always --tree --all"
aliases["shh"] = "(@($args) all>/dev/null &)"

@aliases.register
@aliases.return_command
def nix(args):
    if args and len(args) >= 1:
        args.insert(1, "-L")
    if args and ( args[0] == "run" or args[0] == "develop" ):
        return [$(which .any-nix-wrapper), "xonsh"] + args
    else:
        return [$(which -s nix)] + args
