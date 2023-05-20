package main

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"regexp"
	"sort"
	"strings"

	"github.com/alecthomas/kong"
)

type arguments []string

func (a *arguments) Pop() string {
	args := *a

	if len(args) > 0 {
		arg := args[0]
		args = args[1:]
		*a = args
		return arg
	}

	return ""
}

var cli struct {
	Inbox       InboxCmd       `cmd:"" help:"Create a new Bulletnotes document in the project's inbox"`
	EditSession EditSessionCmd `cmd:"" name:"es" help:"Start/resume an edit session in the project"`
	Open        OpenCmd        `cmd:"" name:"open" aliases:"op" help:"Open project"`
	NewProj     NewProjCmd     `cmd:"" name:"newproj" help:"Create a new Bulletnotes project"`
	Ls          LsCmd          `cmd:"" help:"List Bulletnotes projects"`
}

func main() {
	ctx := kong.Parse(&cli)
	err := ctx.Run()
	ctx.FatalIfErrorf(err)
}

type NewProjCmd struct {
	Name string `arg:"" help:"The name of the new project"`
}

func (cmd *NewProjCmd) Run() error {
	// TODO: Confirm
	name := normaliseProjName(cmd.Name)

	if os.Getenv("BN_NEW_REMOTE") == "" {
		panic("BN_NEW_REMOTE must be set")
	}

	logInfo("Creating empty project directory...")
	cdBnHome()
	if err := os.Mkdir(name, 0o755); err != nil {
		if os.IsExist(err) {
			// logError(fmt.Sprintf("Project %s already exists", name))
			return fmt.Errorf("Project '%s' already exists", name)
		} else {
			return err
		}
	}
	cd(name)

	logInfo("Initialising git repo...")
	mkdir(".bnproj", ".bnproj/spell", ".bnproj/snips", "Inbox")
	run("touch", ".bnproj/spell/.keep", ".bnproj/snips/.keep", "Inbox/.keep")
	run("git", "init")
	run("git", "config", "commit.gpgsign", "false")
	run("git", "checkout", "-b", name)
	run("rm", "-rf", ".git/hooks")
	run("git", "add", "--all")
	run("git", "commit", "-m", "Initial Commit")

	// TODO: Rethink this
	remote := getOutput(os.Getenv("BN_NEW_REMOTE"), name)
	run("git", "remote", "add", "origin", remote)
	run("git", "push", "-u", "origin", name)

	return nil
}

type OpenCmd struct {
	Proj string `arg:"" help:"The project to open"`
}

func (cmd *OpenCmd) Run() error {
	if err := chProjDir(cmd.Proj); err != nil {
		return err
	}

	commit := headCommit()

	vim("-c", "BulletnotesAsyncStartIndex")
	if commit != headCommit() {
		// Note that this could also happen if new changes were pulled but no
		// new commits were created, but this has no negative effects
		push()
	}

	return nil
}

type EditSessionCmd struct {
	Proj  string `arg:"" help:"The project to begin/resume the edit session in"`
	Fresh bool   `short:"f" help:"Start a fresh edit session"`
}

func (cmd *EditSessionCmd) Run() error {
	if err := chProjDir(cmd.Proj); err != nil {
		return err
	}

	// Check if .sessions/_active file exists
	if fileExists(".sessions/_active") {
		return errors.New("An edit session is already active")
	}

	commit := headCommit()

	mkdir(".sessions")
	run("touch", ".sessions/_active")
	defer os.Remove(".sessions/_active")

	if cmd.Fresh {
		os.Remove(".sessions/Session.vim")
	}

	if fileExists(".sessions/Session.vim") {
		vim("-S", ".sessions/Session.vim", "-c", "BulletnotesAsyncStart")
	} else {
		vim("-c", "Obsession .sessions/Session.vim", "-c", "BulletnotesAsyncStartIndex")
	}

	if commit != headCommit() {
		// Note that this could also happen if new changes were pulled but no
		// new commits were created, but this has no negative effects
		push()
	}

	return nil
}

type InboxCmd struct {
	Proj  string `arg:"" help:"The project to create the document in"`
	Title string `arg:"" optional:"" help:"The title of the document"`
}

func (cmd *InboxCmd) Run() error {
	if err := chProjDir(cmd.Proj); err != nil {
		return err
	}

	pull()

	commit := headCommit()

	vim("-c", fmt.Sprintf("Inbox %s", cmd.Title))

	if commit != headCommit() {
		push()
	}

	return nil
}

type CloneCmd struct {
	Proj string `arg:"" help:"The project to clone"`
}

func (cmd *CloneCmd) Run() error {
	name := normaliseProjName(cmd.Proj)

	if os.Getenv("BN_GET_REMOTE") == "" {
		panic("BN_GET_REMOTE must be set")
	}

	logInfo("Creating empty project directory...")
	cdBnHome()

	// Check if the directory already exists
	if _, err := os.Stat(name); errors.Is(err, fs.ErrNotExist) {
		return fmt.Errorf("Project '%s' already exists", name)
	} else if err != nil {
		return err
	}

	// TODO: Rethink this
	remote := getOutput(os.Getenv("BN_GET_REMOTE"), name)
	run("git", "clone", remote, name)

	cd(name)

	run("git", "config", "commit.gpgsign", "false")
	run("git", "checkout", "-b", name)
	run("rm", "-rf", ".git/hooks")

	return nil
}

type LsCmd struct {
	Remote bool `short:"r" help:"List remote projects"`
}

func (cmd *LsCmd) Run() error {
	if cmd.Remote {
		if os.Getenv("BN_LS_REMOTE") == "" {
			panic("BN_LS_REMOTE must be set")
		}

		// TODO: Save to $BN_HOME/remotes_cache
		remoteProjs := getOutput(os.Getenv("BN_LS_REMOTE"))
		fmt.Print(remoteProjs)
	} else {
		// Get list of contents of BN_HOME
		items, err := os.ReadDir(os.ExpandEnv("$BN_HOME"))
		if err != nil {
			return err
		}

		var dirs []string

		for _, item := range items {
			if item.IsDir() {
				dirs = append(dirs, item.Name())
			}
		}

		sort.Strings(dirs)

		fmt.Println(strings.Join(dirs, "\n"))
	}

	return nil
}

// Utils

func normaliseProjName(name string) string {
	name = strings.ToLower(name)
	name = strings.ReplaceAll(name, " ", "-")
	name = regexp.MustCompile(`[^a-z-]+`).ReplaceAllString(name, "")
	return name
}

func logInfo(msg string) {
	log(220, msg)
}

func logError(msg string) {
	log(196, msg)
}

func logSuccess(msg string) {
	log(46, msg)
}

func log(col int, msg string) {
	fmt.Printf("\033[38;5;%dm%s\033[0m\n", col, msg)
}

// Shell-like commands

func vim(arg ...string) {
	cmd := exec.Command("vim", arg...)
	cmd.Env = append(os.Environ(), "BN_PROJ=1")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		panic(err)
	}
}

func mkdir(paths ...string) {
	for _, p := range paths {
		if err := os.MkdirAll(p, 0o755); err != nil {
			panic(err)
		}
	}
}

func pull() {
	logInfo("Pulling changes...")
	run("git", "pull", "--rebase")
}

func push() {
	logInfo("Pushing changes...")
	run("git", "push")
}

func run(prog string, args ...string) {
	cmd := exec.Command(prog, args...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		panic(err)
	}
}

// getOutput runs a command with the given arguments and returns the output
func getOutput(prog string, args ...string) string {
	cmd := exec.Command(prog, args...)
	cmd.Stdin = os.Stdin
	cmd.Stderr = os.Stderr
	if output, err := cmd.Output(); err != nil {
		panic(err)
	} else {
		return string(output)
	}
}

func projDir(proj string) string {
	return os.ExpandEnv(fmt.Sprintf("$BN_HOME/%s", proj))
}

func chProjDir(proj string) error {
	pd := projDir(proj)

	if !dirExists(pd) {
		return fmt.Errorf("Project '%s' does not exist", proj)
	}

	cd(projDir(proj))

	return nil
}

func cdBnHome() {
	cd(os.ExpandEnv("$BN_HOME"))
}

func fileExists(path string) bool {
	stat, err := os.Stat(path)

	if err != nil && !errors.Is(err, fs.ErrNotExist) {
		panic(err)
	}

	return err == nil && !stat.IsDir() && stat.Mode().IsRegular()
}

func dirExists(path string) bool {
	stat, err := os.Stat(path)

	if err != nil && !errors.Is(err, fs.ErrNotExist) {
		panic(err)
	}

	return err == nil && stat.IsDir()
}

func cd(path string) {
	if err := os.Chdir(path); err != nil {
		panic(err)
	}
}

func headCommit() string {
	return getOutput("git", "rev-parse", "HEAD")
}
