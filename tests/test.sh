#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
export VAGRANT_LOG=error
PASSED=0
FAILED=0

echo "Running ansible tests"
echo

echo "[ansible test] - Bringing up vagrant hosts" >> test.log
vagrant up --no-provision >> test.log 2>&1

echo "[ansible test] - Syntax check" >> test.log
ansible-playbook --syntax-check role.yml -i dummy.hosts >> test.log \
    && { ((PASSED++)); echo "[ansible test] - Syntax check: pass"; } \
    || { ((FAILED++)); echo "[ansible test] - Syntax check: fail"; }

for vm in "invalid-tz"; do
    vagrant provision $vm 2>&1 | tee -a test.log | grep -q 'msg: The specified timezone is not available' \
        && { ((PASSED++)); echo "[ansible test] - Invalid timezone check: pass"; } \
        || { ((FAILED++)); echo "[ansible test] - Invalid timezone check: fail"; }
done

for vm in "centos7" "centos6" "precise" "trusty" "wheezy"; do
    echo "[ansible test] - Provisioning vm $vm" >> test.log
    vagrant provision $vm >> test.log 2>&1
    vagrant provision $vm 2>&1 | tee -a test.log | grep -q 'changed=0.*unreachable=0.*failed=0' \
        && { ((PASSED++)); echo "[ansible test] - $vm idempotence: pass"; } \
        || { ((FAILED++)); echo "[ansible test] - $vm idempotence: fail"; }
done

if [ $FAILED -ne 0 ]; then
    echo
    echo "$FAILED tests failed, please check the log."
fi

echo
echo "Ran $((PASSED + FAILED)) ansible tests - Passed: $PASSED - Failed: $FAILED"

echo 
echo "Running serverspec tests"
echo

rake vagrant

#vagrant destroy -f
