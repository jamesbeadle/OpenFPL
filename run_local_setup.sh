
# Call this from an independant terminal

DX_NET_JSON="${HOME}/.config/dfx/networks.json"
mkdir -p "$(dirname "${DX_NET_JSON}")"
cp "$DX_NET_JSON" "${DX_NET_JSON}.tmp" 2>/dev/null  # save original config if present
echo '{
   "local": {
      "bind": "0.0.0.0:8080",
      "type": "ephemeral",
      "replica": {
         "subnet_type": "system",
         "port": 8000
      }
   }
}' > "${DX_NET_JSON}"
../sns-testing/bin/dfx start --clean; \
mv "${DX_NET_JSON}.tmp" "$DX_NET_JSON" 2>/dev/null  # restore original config if it was present