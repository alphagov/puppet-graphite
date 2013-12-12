# Edit this file to override the default graphite settings, do not edit settings.py

# Turn on debugging and restart apache if you ever see an "Internal Server Error" page
#DEBUG = True

# Set your local timezone (django will try to figure this out automatically)
TIME_ZONE = '<%= @django_timezone %>'

# Setting MEMCACHE_HOSTS to be empty will turn off use of memcached entirely
#MEMCACHE_HOSTS = ['127.0.0.1:11211']

# Sometimes you need to do a lot of rendering work but cannot share your storage mount
#REMOTE_RENDERING = True
#RENDERING_HOSTS = ['fastserver01','fastserver02']
#LOG_RENDERING_PERFORMANCE = True
#LOG_CACHE_PERFORMANCE = True

# If you've got more than one backend server they should all be listed here
#CLUSTER_SERVERS = []

# Override this if you need to provide documentation specific to your graphite deployment
#DOCUMENTATION_URL = "http://wiki.mycompany.com/graphite"

# Enable email-related features
SMTP_SERVER = "<%= @smtp_server %>"

# LDAP / ActiveDirectory authentication setup
USE_LDAP_AUTH = <%= @use_ldap_auth %>
<% if @use_ldap_auth -%>
LDAP_SERVER = "<%= @ldap_server %>"
LDAP_PORT = <%= @ldap_port %>
LDAP_SEARCH_BASE = "<%= @ldap_search_base %>"
LDAP_BASE_USER = "<%= @ldap_base_user %>"
LDAP_BASE_PASS = "<%= @ldap_base_pass %>"
LDAP_USER_QUERY = "<%= @ldap_user_query %>"
<% end -%>

# If sqlite won't cut it, configure your real database here (don't forget to run manage.py syncdb!)
#DATABASE_ENGINE = 'mysql' # or 'postgres'
#DATABASE_NAME = 'graphite'
#DATABASE_USER = 'graphite'
#DATABASE_PASSWORD = 'graphite-is-awesome'
#DATABASE_HOST = 'mysql.mycompany.com'
#DATABASE_PORT = '3306'
SECRET_KEY='<%= @django_secret_key -%>'