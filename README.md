# gg-iac
Infrastructure as Code for Interviews

### Ansible Virtual Environment

```
python3 -m venv /var/tmp/gg-iac
source /var/tmp/gg-iac/bin/activate
pip install -r requirements.txt
```

```
OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ANSIBLE_CONFIG=ansible.cfg ansible-playbook ./server.yml --extra-vars "server_name=lab" --diff
```
