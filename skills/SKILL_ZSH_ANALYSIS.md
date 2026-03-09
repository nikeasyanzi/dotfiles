# Zsh History Analysis — Skill Suggestions

Based on analysis of ~5350 commands from `~/.zsh_history`.

---

## 1. 🐳 Docker Nuke — Stop & Remove All Containers + Prune

**Frequency**: Very high (20+ occurrences of variations)
**Pain**: Multi-step, error-prone loop every time

Observed patterns:
```bash
for i in $(docker ps -a | awk '{print $1}'); do docker stop $i & docker kill $i && docker rm $i; done
docker rmi <hash> <hash> ...
docker system prune
docker rmi $(docker images -q)
```

**Proposed skill**: `docker-nuke` — one command to stop all containers, remove them, optionally remove all images, and prune.

---

## 2. 🧹 Brew Maintenance

**Frequency**: High (~15 occurrences)
**Pain**: Always the same 3-4 commands in sequence

Observed patterns:
```bash
brew update
brew upgrade
brew autoremove
brew cleanup
```

**Proposed skill**: `brew-maintain` — run the full homebrew maintenance cycle in sequence.

---

## 3. 📝 Hugo Blog Post

**Frequency**: Medium-high (~12 occurrences)
**Pain**: Repeated steps for new posts, especially with dual language setup

Observed patterns:
```bash
hugo new posts/<title>.md
cp content/tw/posts/<file> content/en/posts/
hugo server -D
hugo --minify
```

**Proposed skill**: `blog-new` — create a new bilingual blog post (tw + en) with front matter template, then optionally start hugo server.

---

## 4. 🔧 UV Python Project Setup

**Frequency**: High (~20 occurrences)
**Pain**: Repeated init + add + sync cycle

Observed patterns:
```bash
uv init
uv venv
uv add <packages>
uv sync
uv run python <script>
uv pip install <package>
```

**Proposed skill**: `uv-new` — scaffold a new Python project with uv (init, venv, add common dev deps, create src/ and tests/ structure).

---

## 5. 🔑 SSH Quick Connect

**Frequency**: Medium (~10 occurrences)
**Pain**: Typing long SSH/SCP commands with IPs and options

Observed patterns:
```bash
ssh craigyang@192.168.54.128
ssh craigyang@192.168.54.130
ssh craigyang@192.168.54.131
scp <file> craigyang@192.168.54.131:~/
sftp craigyang@192.168.54.130
ssh-copy-id -i $HOME/.ssh/id_ed25519.pub craigyang@<ip>
```

**Proposed skill**: `sssh` — interactive SSH/SCP/SFTP launcher with saved host aliases (read from a config file).

---

## 6. 📦 Git Project Init + First Push

**Frequency**: Medium (~8 occurrences)
**Pain**: Same 5-6 commands every time for a new repo

Observed patterns:
```bash
git init
git add -A
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:nikeasyanzi/<repo>.git
git push -u origin main
```

**Proposed skill**: `git-kickstart` — initialize a repo, make first commit, set remote to github.com/nikeasyanzi/<name>, and push.

---

## 7. 🗃️ Download-to-Project Mover

**Frequency**: Very high (~25+ occurrences)
**Pain**: Constantly moving files from ~/Downloads/ to current project

Observed patterns:
```bash
mv ~/Downloads/<file> ./
mv ~/Downloads/*.env ./.env
mv ~/Downloads/*.tar.gz ./
```

**Proposed skill**: `grab` — interactive picker for recent files in ~/Downloads, moves selected file to current directory (with optional rename).

---

## 8. 🔄 Git Interactive Rebase Helper

**Frequency**: Medium (~6 occurrences)
**Pain**: Remembering rebase syntax, fixing up commits

Observed patterns:
```bash
git rebase -i HEAD~8
git rebase -i HEAD~68
git rebase --continue
git rebase --abort
git commit --amend
```

**Proposed skill**: `git-squash` — interactive rebase with smart defaults (auto-detect number of unpushed commits, or specify count).

---

## 9. 🖥️ QEMU/OpenBMC Runner

**Frequency**: Medium (~5 occurrences, but very complex)
**Pain**: Very long command with port forwarding options

Observed patterns:
```bash
qemu-system-aarch64 -m 256 -M romulus-bmc -nographic \
  -drive file=./obmc-phosphor-image-romulus.static.mtd,format=raw,if=mtd \
  -net nic -net user,hostfwd=:127.0.0.1:2222-:22,hostfwd=:127.0.0.1:2443-:443,hostfwd=udp:127.0.0.1:2623-:623,hostname=qemu
```

**Proposed skill**: `run-bmc` — wrapper that takes an MTD image path and launches QEMU with the correct flags.

---

## 10. 📋 Clang-format Batch

**Frequency**: Medium (~8 occurrences)
**Pain**: Running clang-format -i on each file individually

Observed patterns:
```bash
clang-format -i gpio_handle.cpp
clang-format -i fan_pwm.cpp
clang-format -i fan_speed.cpp
clang-format -i mainloop.cpp
```

**Proposed skill**: `fmt-cpp` — run clang-format in-place on all C/C++ files in the current directory (or specified files).

---

## 11. 🧪 Docker Compose Lifecycle

**Frequency**: High (~15 occurrences)
**Pain**: Long compose commands, file specification

Observed patterns:
```bash
docker-compose -f ./docker-compose.yaml up -d
docker-compose -f ./docker-compose.yaml down
docker compose -f docker-compose-cadvisor.yaml up -d
docker-compose up --build
```

**Proposed skill**: `dc` — shortcut for docker-compose with auto-detection of compose file name (docker-compose.yml, docker-compose.yaml, compose.yml).

---

## 12. 🏗️ Tar + SCP Deploy

**Frequency**: Medium (~5 occurrences)
**Pain**: Tar, SCP, then cleanup

Observed patterns:
```bash
tar cvf 123.tar ~/.config/nvim
scp 123.tar craigyang@192.168.54.131:~/
rm 123.tar
```

**Proposed skill**: `ship` — tar a directory, SCP it to a remote host, and clean up the local tar file.

---

## Priority Matrix

| Skill | Effort | Impact | Priority |
|-------|--------|--------|----------|
| docker-nuke | Low | High | ⭐⭐⭐ |
| brew-maintain | Low | Medium | ⭐⭐⭐ |
| grab (download mover) | Low | High | ⭐⭐⭐ |
| blog-new | Medium | High | ⭐⭐ |
| git-kickstart | Low | Medium | ⭐⭐ |
| dc (compose shortcut) | Low | Medium | ⭐⭐ |
| uv-new | Medium | Medium | ⭐⭐ |
| fmt-cpp | Low | Low-Med | ⭐ |
| sssh | Medium | Medium | ⭐ |
| git-squash | Low | Low-Med | ⭐ |
| ship | Low | Low | ⭐ |
| run-bmc | Low | Low (niche) | ⭐ |
