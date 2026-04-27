FROM cgr.dev/chainguard/node:latest-dev

USER root
RUN apk add --no-cache \
        curl \
        ca-certificates \
        git \
        openssh-client \
        tmux \
        gcc \
        clang \
        make

# mise GPG key from https://github.com/jdx/mise/security#release-gpg-key
RUN <<'EOF'
set -e
apk add --no-cache gpg gpg-agent
cat > /tmp/mise-release.asc <<'KEYEOF'
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBGWUNRYBEAC1Sz9QTV039Kxez3Olzf0bLPKFjyRovwx1sTCUZUfkYid9qlSw
4VyWb5M51Og3mSwwD+p55aMMESapqIAer16Mh+rVy2TfYcQ42HfYjoDrgrBlV8Cw
FutPowt7FpdmUEH4I4ax4fE4gvlHzRXksHQHqDNFcBxSKGnwakknLEOQqW0FEIMH
BJSPyFTOp8tPqvOXlYXWuL1Kk4dc0MQujk5NbKznWP4VSTBEJgamTDlOg9FEYBQq
H/zSN7X8X2GBA+D9LqHX+ZBzlvQen2LSD4nl4EhKNOZy7C/bfaOKt4olxhGSrw9+
d7s/LfqmgjN508Wnzih3PS8VwvfDI04ch0s0SDUfYh8z8atEddc9mXCv9/YSNtl3
/QAHIEX4E5arqY7OYlRyazR7otCihPeL5rjTSfhw/g1In6IfZsY+CmobvCuBQj9B
SDJQR+mOawV4T758oDkOtbg1Got0vXGog9yXKulYgzC6/8eX7rcXIsK7qdQTrjy5
N/vwjevcZB2Y7rpD+9GZzMj112W9X6eFDxMrV+Os6DsS7FRPtCzUlm8Yth/BQoSr
Fx90eBTSxCeEtpDDnpUtcYX0jTJHChenoxNnTTCeQVdtcJPcZL8Kf5yVq/JFu/07
ZD4LlvPIzpI1myjQyDlXWdsn/N10xDEFl067dkpLvF01fayI7A2UbUOl9QARAQAB
tCRtaXNlIHJlbGVhc2VzIDxyZWxlYXNlQG1pc2UuamR4LmRldj6JAlQEEwEIAD4W
IQQkhT7J9lXOgLSObDqLgcnRdBOgbQUCZZQ1FgIbAwUJB4YfbAULCQgHAgYVCgkI
CwIEFgIDAQIeAQIXgAAKCRCLgcnRdBOgbSpGEACYUWzLT0rJU+BB4K8qF80l5GCz
pffI2CkTVgmrdIVIlDnKFjNYFDd3RJsFx5oK77cnyHzKhQzZ0vsm9Q7EGgTMPC7t
2m2dNMo8t8YGMveUO9JNhr5GE9OuXGWkxW0FC5lOkkzR1CqsqBAGRa/962t6TAdI
WjxB0U/Dw/CI7Mx59hRDi4em7Fal366DkBw2didyz8xnRatCsBuua+tgIklAawfl
y4kVO99ezGveFElAizns1h7GwANyw5OSQWRDiqXuqnsvC3jMC35aYJmbyBDYgzdD
MQke/uxqvvAWLmmZLEO66urkvDPcgVtC1RJyLVqLSybq6eyBgCs7GwPugKq+T9Gx
cW/LPodyWzCqXSua1yC/JXAivbcHOyO//hhwNVtaSSfkV6jqQJwiXizFSFiEvhRj
tD8tWo2Ivq4j/77J8gpWw0ca/PUPu5hSSSSp/HH89/8S/o67IeqK5t9EpiIBF0j8
ilX2k0veGA1bOgHuMoB6HYOSlEObhDcCqqNcrRPYBhWH2V2U6u4iQptahOTRGO0d
TU+oLDAo+bwB8Xo8ZTEm3QaZVhK/FWzJLVj2lxQodAf0NRbu2JtMdNnovLjI8Czm
/7N/0rvtcWOu2fCKE5NtEgVZzN4GC1KNSnc4M1ml6KyRDI+/ooIdUiKKfkqmSeih
XHj/dpbh3RKIaDuzErkCDQRllDUWARAAxZLN856RxZH4FbPQDZZQn/TgGfrLZehu
g1M5DyEP5UNj2r+/l2dWybWzkE7jVK2sbaqHeGUuH18e0jpWIWCNHg0Y4aqZc8HK
/Sgn7APWzNOSbl2ZAjXwoEtKpP7RyOSPr+1f3t1S5qy0DjdGCeCbnnQ2Ju5//lR5
N2QdiuM+XtBW7oW0g5qkmsonCLpjqrAaQwnHJUw5TUTlQODz3OX6ZG1gIksI4kdw
wmTGqzpxDx58gfptYHQ+U55k4qUDG4d7XGOo4KAiJ990s+W3D+O6I//z7eKQMfbC
30+K/sizvi46QICuj44BtCA9fy6h9fRiK1f0gDqBopUNR9QHIP5RPvQtVjAtaYFl
AD5ZWcnFyrF79dzCC/SbGtAwi249UdCbuVwTH1U+csjkp11K0KMzcD60RQXEKi0U
ISF4STqsPyN0Dp08M6qS8i5334f4AZN61piFkrxDiEsvGE11WsWDDXzkvNNGLN1f
pG+O58pBHbAVsUxDmuUrbHXAtXhxiXsqU1PA9l6QZnB0qe6/i2EjCXM+/0eF2jfP
dfRGCJEb9SdBR2fBZufbE7ytCBwTSNpN7h5GyMPCIq4vLluEQVRm3izwU5RMrvj6
BaNgE9gnCspmRmpVABodRbzAflBrGb4Bole5iUwT7puB1J87rkxe+8m6XcJFAGJN
iX0CLLUEKHkAEQEAAYkCPAQYAQgAJhYhBCSFPsn2Vc6AtI5sOouBydF0E6BtBQJl
lDUWAhsMBQkHhh9sAAoJEIuBydF0E6BtoV4P/193pUjxgyojg0G2ELaxrBqtKAVN
g1FJABox/C2Lx334W1UyoMiSFkMIdky6xl8zzz3HciQHVeGzRvW//eM810LxLkVK
WNkVoTgyJV5Voo+TmXyfjaghFQqygCv/MboTcRE3mJh2P0ND+aEJKaXs/2l5suyB
lq/yOWPFYxR5DhVpQLfuctTUAoxQsi6gYu1b7h3d4x22RFo3RL4g/fDvNGIeDpmQ
BEOfUDrHfoFt5jZiYmW9E+yrP4hMeV4ujiIb3a0iSx0u4NBGHmGVg+QQ6E6knF6w
iz4LPL6Ze/F8eg7b9gvqeDMh7sJ0eJIkBKly/0OUKWedH+FSZASdTK183QuPB3x3
sgna2IHECprmdWPWdnGet+8cbQB5R59Qs8WgV9k2JOzUOjzKkl5mQv2uHcSRGGze
8Uosc4bAr0dDtCUsIY6w8E7lq2V75EV/BWtbyySWjt1ZXHsykNh1QBUZw7e/krBZ
j4Mt0KoL2YxkI4qnqoVAEqd20Rxvisd+RyeA7L3AnxGlaPVj7iibu4XW9P5stUom
jLQEDnl7ewfTeBbeIH7+EXuTGZttnKN7BOestODBGsD1r7zTKrJfL+MvGO4rG9KT
9/Q4udpmXDdm4Lze+xm7bLfl3wkXpLLoVs2fndegkj/sSBL2IbhtMjOerEbafK6K
S1GIqgTqW7TRaQRg
=yIM2
-----END PGP PUBLIC KEY BLOCK-----
KEYEOF
gpg --import /tmp/mise-release.asc
curl -fsSL https://mise.jdx.dev/install.sh.sig -o /tmp/mise-install.sh.sig
gpg --decrypt /tmp/mise-install.sh.sig > /tmp/mise-install.sh
MISE_VERSION=2026.4.18 MISE_INSTALL_PATH=/usr/local/bin/mise sh /tmp/mise-install.sh
rm /tmp/mise-install.sh.sig /tmp/mise-install.sh
apk del gpg gpg-agent
EOF

ARG MISE_DATA_DIR=/usr/local/share/mise
ENV MISE_DATA_DIR=/usr/local/share/mise

RUN mise plugins install nim https://github.com/mise-plugins/mise-nim

RUN mise use -g bun@1.3.11 \
    && mise use -g rust@1.95.0 \
    && mise use -g go@1.26.2 \
    && mise use -g zig@0.15.2 \
    && mise use -g nim@2.2.10 \
    && mise use -g uv@0.11.7

RUN ln -s /usr/local/share/mise/shims/bun /usr/local/bin/bun \
    && ln -s /usr/local/share/mise/shims/cargo /usr/local/bin/cargo \
    && ln -s /usr/local/share/mise/shims/rustc /usr/local/bin/rustc \
    && ln -s /usr/local/share/mise/shims/rustup /usr/local/bin/rustup \
    && ln -s /usr/local/share/mise/shims/rustfmt /usr/local/bin/rustfmt \
    && ln -s /usr/local/share/mise/shims/clippy-driver /usr/local/bin/clippy-driver \
    && ln -s /usr/local/share/mise/shims/go /usr/local/bin/go \
    && ln -s /usr/local/share/mise/shims/gofmt /usr/local/bin/gofmt \
    && ln -s /usr/local/share/mise/shims/zig /usr/local/bin/zig \
    && ln -s /usr/local/share/mise/shims/nim /usr/local/bin/nim \
    && ln -s /usr/local/share/mise/shims/nimble /usr/local/bin/nimble \
    && ln -s /usr/local/share/mise/shims/uv /usr/local/bin/uv \
    && ln -s /usr/local/share/mise/shims/uvx /usr/local/bin/uvx

RUN uv python install 3.14.4 \
    && ln -s "$(uv python find 3.14.4)" /usr/local/bin/python3

RUN cat > /usr/local/share/mise/config.toml << 'EOF'
[tools]
bun = "1.3.11"
rust = "1.95.0"
go = "1.26.2"
zig = "0.15.2"
nim = "2.2.10"
uv = "0.11.7"
EOF


RUN mkdir -p /app && chmod 0777 /app

RUN mkdir -p /root/.local/bin && \
    mise exec bun -- bun install -g @oh-my-pi/pi-coding-agent && \
    ln -sf /root/.bun/bin/omp /root/.local/bin/omp

ENV PATH="/usr/local/share/mise/shims:/root/.local/bin:/root/.cargo/bin:/root/.nimble/bin:/root/go/bin:/root/.bun/bin:${PATH}"
ENV HOME=/root
ENV MISE_CONFIG_FILE=/usr/local/share/mise/config.toml

WORKDIR /app

ENTRYPOINT ["omp"]
