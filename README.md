# gg-iac

[![GitHub Super-Linter](https://github.com/mlintern/gg-iac/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

Infrastructure as Code for Interviews

## Ansible Virtual Environment

```bash
python3 -m venv /var/tmp/gg-iac
source /var/tmp/gg-iac/bin/activate
pip install -r requirements.txt
```

## Ansible Requirements

```bash
/var/tmp/gg-iac/bin/ansible-galaxy install -r requirements.yml
```

## Ansible Run

```bash
OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ANSIBLE_CONFIG=ansible.cfg ansible-playbook ./server.yml --extra-vars "server_name=lab" --diff
```
