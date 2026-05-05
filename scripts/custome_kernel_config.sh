#!/bin/bash

CONFIGS=(
  "CONFIG_NET_ACT_CT=m"
  "CONFIG_NET_ACT_CTINFO=m"
)

source .current_config.mk
KCFG=kernel/arch/arm64/configs/$(awk '{print $1}' <<< "$TARGET_KERNEL_CONFIG")

for CFG in "${CONFIGS[@]}"; do
  KEY=${CFG%%=*}
  if grep -q "^#\?${KEY}=" "${KCFG}"; then
    sed -i "s@^#\?${KEY}=.*@${CFG}@g" "${KCFG}"
  else
    echo "$CFG" >> "${KCFG}"
  fi
  # 开启DAE所需的eBPF/BTF支持
echo "CONFIG_BPF=y" >> .config
echo "CONFIG_BPF_SYSCALL=y" >> .config
echo "CONFIG_BPF_JIT=y" >> .config
echo "CONFIG_BPF_STREAM_PARSER=y" >> .config
echo "CONFIG_DEBUG_INFO=y" >> .config
echo "CONFIG_DEBUG_INFO_BTF=y" >> .config
# 开启Full Cone NAT
echo "CONFIG_NF_NAT_FULLCONENAT=y" >> .config

done
