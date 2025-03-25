#!/bin/bash

# Script to install certbot and obtain SSL certificate using acme-dns-auth
# Usage: ./script.sh <domain>

# Exit on any error
set -e

# Log file location
LOG_FILE="/var/log/certbot_install.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to log and echo messages
log_message() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# Check if domain is provided
if [ -z "$1" ]; then
    log_message "${RED}Error: No domain provided. Usage: $0 <domain>${NC}"
    exit 1
fi

DOMAIN="$1"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log_message "${RED}Error: This script must be run as root${NC}"
    exit 1
fi

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

log_message "[$TIMESTAMP] Starting certificate installation for $DOMAIN"

# Install dependencies
log_message "Installing EPEL release and certbot..."
if ! dnf -y install epel-release certbot >> "$LOG_FILE" 2>&1; then
    log_message "${RED}Error: Failed to install dependencies${NC}"
    exit 1
fi

# Create acme-dns-auth.py from base64 encoded content
log_message "Creating acme-dns-auth.py..."
cat <<'EOF' | base64 -d | gunzip > /etc/letsencrypt/acme-dns-auth.py 2>> "$LOG_FILE"
H4sICDCb2WcAA2FjbWUtZG5zLWF1dGgucHkApVhtU+M4Ev6eX6E1H0h2gwPc1dRcqtiqbPAMuWFi
KvHs7BVLuYytEO84kk+SgSzLf79uSX5NYNg6fwDH6m71y9Otbh38MCqkGN2mbETZPcm3as3ZP3rp
JudCkT8kZ+U7l+WboP8tqFTVb7mVvd7BwQHxzmcBCS68pTcmU85W6V0hIpVyRu6jDFgIEAEl+bK4
JIqTKN7Qo4RJkjKpIhbT3mT62TufL0MkOCPOWqlcjkejqFBrt6R2U+6AjKtIrcmKi1pKLGhCmUqj
jEjFRXRHe8vAX0w+euHVJLhAgSOq4lFGlaQsFttcjZAZZaKhKPXrOlU0S6UyopNEUCmJiNgdaI8q
Zxl/IGpNSZEnkYKPK8E3wOg9Rps8o2Myubz0v4YfFv5n2PDaOfnXqXvy7r17cuwej07/6QyJMx6f
jE5O3zs3vTbtDYj5wEVMwcFHgt6BFsZ7LvHvqXgQKe6He0eZoFGyJfQRaFJ2V/sgimNeMCXd3gd/
MfXChfdxtgy8Bcj/EGWSmjgRcu6TuR+YgP3igRYQttmSXPmzeQDLGCdDaJ4Lb+EBHTkHb/rzZfXd
BPTc/zyZzWELLl0AUSo4u3am3iL4xQ9CswjGpiti3l0ItlDyIVXrvvOj6wzGPaJVslLMy/Xp+Kb3
6+Rydj4JZv48rJadUFsbryEWFOLiOj+ZtSZ14H/yXtKoJgOter04iyDEE5B5zuQ0SwFCfX77B42V
VcxxHP3/ImJJZiMQ882mYGls0I2mEMTuEYCXTK5mFZ9+SeiKhGHKUhWGfUmz1ZBY3IWFyOwu+OCa
21gCAxq/amEGHFSENtylUAQn4rEhEpRYWGpAB2H0oVbUcld64gNRqsTUUnSoyYzFWZFQ8lAmCU1A
oHrg4ptODnRME7ckBlEtGbAaQtpEYNiTU+3jjOs9nzv0EkjLeuPmXBpbm076yRmV/nCGLe59D+5+
htnuJsUml/1So8GgYqWQJ+P/S41B053AjIhXhQxjDt47OyOnxydd3wbad3oD8hBJIos4htKzKroO
VIVgWiYa0X9NayhKTAeYQmEkESNUCC5aJBt5B4b1nX2EGOaMEiW2WGEgvKV5FkZVzXH2Od2x4HLJ
RRBcEeMA8vQ8JAsqc84kJbc82Y7hU8Nd+OQiBUSDZi6U4E2k+h0HDrX1ij6qQZsRjiEXKqLqnwzq
VDFlOlSPKhQ05iKpElCrNySw0k6XL7awI5qD3wJSFRpiBKArqhSSxW3CN1HK3LJK4GM21SCvCBDk
Zs/rw+rj4Q2cB6ABLMLfGvtrKO+YsCjht6NJnh59kYCrhogCfrNoQ0HCXvcbrk9022TKodJBtiYv
McGZraD8HQXbnAKfE+V5ZmvcSJ+QtYZvTAnjie/kpbX2zP5/nbibwGaHwfdT7ribHcsqxWzA9mTa
K+n1t3LHIgLxZFGUshcTx/Y55He2n+LIPJBJpl5Yv41/Z0/Pb+XRyfc2BpuujTzGrH0z3wtpLsMa
5I1wlhgA/2Azd3Y6JBJ6zPAb3cqzQBS0K6XKtR1MvF0GqtiWUBfYt0rZKVuVgcNKy2EXmUO7+WuV
zPQnS9PRtjuTPY2F7Xxz6I67jUVjCYxt/GqTlQe0/pHxKOk3yqn+jSvdFiNKTMW0YqFB0qVEt8d6
IUnlN91Bw1sMM4MSRQwZRpt10+6MBI2TbQWpZFcatJBb7XzUTRjPKet3rR2SQ3E4IHCqrtbjHdA2
xK/WLjbWzVP1Maa5IjPf02kNIjpVAKoN9Ji4i5tKFLWz+2B3ywPis2xrSwUvFEpBXtPQA2Bu4Vsc
McYhUfHciZIdGQZvjrdY+ItxCY+mlD1COinYhdqLrrXu0fmBCJD90mk7nvoVBz3trB0/wSFa85Gf
yfE+x7QMSWGo40IUOXSab3TAv5f+vMX3RpttY4W61WiX0T3dg/YlfN6PdsA34ryJaTinYSJN/4TT
oVVh6lx7xfEG09JdJRrY8LYf4N9te+EBZj/8uvDnl/8hf5lf04U3CYbkmL87PoZCd/jwSpasXchY
Bs0A7e96FFb1eNqvrf0bOdSO5JQXGcwVgFotsvIxIsLtHiL7Wr68KAciKNVDc/XQDuBVocoxbueS
AmNYbgkDH2AAyisYRFLVDCtMQysIT5bEERzmppvD8r7h91SLrtZyGHbRaLUGWMJX6DakJmnIktDJ
4fZpYjSxPQI2eIYVjtEIuMw+zVYHTHxhni4foADkwV89UVeeq+B3DUs3QKGtr724oipe135sO/Aj
VXKv83S5t+5zXqvWNt86anQxA/3rnlpieeecgb4pHoHoqDDEPs8JQ3RRGDqGB6fWVOnXWM/2YGl7
1m/cORlwldE/qw7d5jWSBdoBma5p/E3Py6zssNsXM3ivVd1EIU9JVR2+rnGyub4wm4O8zs0NpAwm
g2UeN1Azhc1UiVILOzOZadKKst7XuMDduT+oL6Lq/Cp1xHQyGlZT0y6RrpSDXkO581TmWbQ1SnGV
rsrLErxY0xdoUCsarTF+wsiRPzGspRzTZDtXGUX4R0mi6VYcrwuwtZ7OJ5+9xmC25YUwYnA6Q1G6
ya2BGOucApFPz5b56dl1yp5t576pMvnagTkhs6PcTe2AnbZPbzCoUPKltq7d/O9eftYYdXen1mpe
7V5yDXr/A2YK4NnDFQAA
EOF

# Verify file creation and set permissions
if [ ! -f "/etc/letsencrypt/acme-dns-auth.py" ]; then
    log_message "${RED}Error: Failed to create acme-dns-auth.py${NC}"
    exit 1
fi

chmod +x /etc/letsencrypt/acme-dns-auth.py || {
    log_message "${RED}Error: Failed to set execute permissions${NC}"
    exit 1
}

# Run certbot
log_message "Running certbot for domain $DOMAIN..."
if certbot certonly \
    --manual \
    --manual-auth-hook /etc/letsencrypt/acme-dns-auth.py \
    --preferred-challenges dns \
    --debug-challenges \
    -d "$DOMAIN"; then
    log_message "${GREEN}Successfully obtained certificate for $DOMAIN${NC}"
else
    log_message "${RED}Error: Certbot failed to obtain certificate${NC}"
    exit 1
fi

log_message "[$TIMESTAMP] Script completed"
