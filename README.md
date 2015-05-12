Role Name
=========

An ansible role for setting the system timezone and configuring a local NTP client daemon.

Role Variables
--------------

  * `clock_timezone` - the timezone to be set. Defaults to `UTC`
  * `clock_ntpd_enable` - if set to `true`, installs and enables a local NTP client daemon. Defaults to `false`.
  * `clock_ntpd_servers` - the list of upstream NTP servers which will be used to keep the system clock in sync.
  * `clock_hwclock_sync` - if set, the hardware clock will be set to the current system time if the timezone is changed; valid values are `utc` or `localtime`. Defaults to `null`.

Example Playbooks
-----------------

Set timezone to Europe/Rome:

        - hosts: servers
          roles:
            - role: corneti.clock
              clock_timezone: Europe/Rome

Set timezone to Europe/Rome and sync hardware clock to UTC time:

        - hosts: servers
          roles:
            - role: corneti.clock
              clock_timezone: Europe/Rome
              clock_hwclock_sync: utc

Set timezone to Europe/Rome and enable ntpd:

        - hosts: servers
          roles:
            - role: corneti.clock
              clock_timezone: Europe/Oslo
              clock_ntpd_enable: true
              clock_ntpd_servers:
                - 0.europe.pool.ntp.org
                - 1.europe.pool.ntp.org
                - 2.europe.pool.ntp.org
                - 3.europe.pool.ntp.org

License
-------

MIT