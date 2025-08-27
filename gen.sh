#!/bin/bash
# Downloads the Go 1.25 sources, building the assembler into a standalone package.
# Updated to handle Go 1.25 changes including internal/buildcfg package and API changes.

OUT_DIR=$(pwd)
BASE_PKG_PATH='github.com/alicemare/golang-asm-v1.25'

TMP_PATH=$(mktemp -d)
cleanup () {
  if [[ "${TMP_PATH}" != "" ]]; then
    rm -rf "${TMP_PATH}"
    TMP_PATH=""
  fi
}
trap 'cleanup $LINENO' ERR EXIT

cd $TMP_PATH
echo "Cloning Go 1.25 source..."
git clone --depth 1 --branch go1.25.0 https://github.com/golang/go

echo "Cleaning existing directories..."
rm -rfv ${OUT_DIR}/{asm,dwarf,obj,objabi,src,sys,bio,goobj,buildcfg,unsafeheader,abi,goarch,goexperiment,hash,bisect}

# Move obj package
echo "Processing obj package..."
cp -rv ${TMP_PATH}/go/src/cmd/internal/obj ${OUT_DIR}/obj
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"cmd/internal/obj_\"${BASE_PKG_PATH}/obj_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"cmd/internal/dwarf_\"${BASE_PKG_PATH}/dwarf_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"cmd/internal/src_\"${BASE_PKG_PATH}/src_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"cmd/internal/sys_\"${BASE_PKG_PATH}/sys_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"cmd/internal/bio_\"${BASE_PKG_PATH}/bio_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"cmd/internal/goobj_\"${BASE_PKG_PATH}/goobj_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"internal/buildcfg_\"${BASE_PKG_PATH}/buildcfg_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"internal/abi_\"${BASE_PKG_PATH}/abi_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"internal/goarch_\"${BASE_PKG_PATH}/goarch_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"cmd/internal/hash_\"${BASE_PKG_PATH}/hash_g" {} \;
find ${OUT_DIR}/obj -type f -exec sed -i "s_\"internal/bisect_\"${BASE_PKG_PATH}/bisect_g" {} \;

# Move objabi package
echo "Processing objabi package..."
cp -rv ${TMP_PATH}/go/src/cmd/internal/objabi ${OUT_DIR}/objabi
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"cmd/internal/obj_\"${BASE_PKG_PATH}/obj_g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"cmd/internal/dwarf_\"${BASE_PKG_PATH}/dwarf_g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"cmd/internal/src_\"${BASE_PKG_PATH}/src_g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"cmd/internal/sys_\"${BASE_PKG_PATH}/sys_g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"cmd/internal/bio_\"${BASE_PKG_PATH}/bio_g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"cmd/internal/goobj_\"${BASE_PKG_PATH}/goobj_g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"internal/buildcfg_\"${BASE_PKG_PATH}/buildcfg_g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"internal/abi_\"${BASE_PKG_PATH}/abi_g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s_\"internal/bisect_\"${BASE_PKG_PATH}/bisect_g" {} \;

# Move arch package
echo "Processing arch package..."
mkdir -pv ${OUT_DIR}/asm
cp -rv ${TMP_PATH}/go/src/cmd/asm/internal/arch ${OUT_DIR}/asm/arch
find ${OUT_DIR}/asm/arch -type f -exec sed -i "s_\"cmd/internal/obj_\"${BASE_PKG_PATH}/obj_g" {} \;
find ${OUT_DIR}/asm/arch -type f -exec sed -i "s_\"cmd/internal/dwarf_\"${BASE_PKG_PATH}/dwarf_g" {} \;
find ${OUT_DIR}/asm/arch -type f -exec sed -i "s_\"cmd/internal/src_\"${BASE_PKG_PATH}/src_g" {} \;
find ${OUT_DIR}/asm/arch -type f -exec sed -i "s_\"cmd/internal/sys_\"${BASE_PKG_PATH}/sys_g" {} \;
find ${OUT_DIR}/asm/arch -type f -exec sed -i "s_\"cmd/internal/bio_\"${BASE_PKG_PATH}/bio_g" {} \;
find ${OUT_DIR}/asm/arch -type f -exec sed -i "s_\"cmd/internal/goobj_\"${BASE_PKG_PATH}/goobj_g" {} \;
find ${OUT_DIR}/asm/arch -type f -exec sed -i "s_\"internal/buildcfg_\"${BASE_PKG_PATH}/buildcfg_g" {} \;
find ${OUT_DIR}/asm/arch -type f -exec sed -i "s_\"internal/abi_\"${BASE_PKG_PATH}/abi_g" {} \;

# Move goobj package
echo "Processing goobj package..."
cp -rv ${TMP_PATH}/go/src/cmd/internal/goobj ${OUT_DIR}/goobj
find ${OUT_DIR}/goobj -type f -exec sed -i "s_\"cmd/internal/obj_\"${BASE_PKG_PATH}/obj_g" {} \;
find ${OUT_DIR}/goobj -type f -exec sed -i "s_\"cmd/internal/bio_\"${BASE_PKG_PATH}/bio_g" {} \;
find ${OUT_DIR}/goobj -type f -exec sed -i "s_\"internal/unsafeheader_\"${BASE_PKG_PATH}/unsafeheader_g" {} \;
find ${OUT_DIR}/goobj -type f -exec sed -i "s_\"internal/buildcfg_\"${BASE_PKG_PATH}/buildcfg_g" {} \;
find ${OUT_DIR}/goobj -type f -exec sed -i "s_\"internal/abi_\"${BASE_PKG_PATH}/abi_g" {} \;

# Move bio package
echo "Processing bio package..."
cp -rv ${TMP_PATH}/go/src/cmd/internal/bio ${OUT_DIR}/bio

# Move unsafeheader package
echo "Processing unsafeheader package..."
cp -rv ${TMP_PATH}/go/src/internal/unsafeheader ${OUT_DIR}/unsafeheader

# Move dwarf package
echo "Processing dwarf package..."
cp -rv ${TMP_PATH}/go/src/cmd/internal/dwarf ${OUT_DIR}/dwarf
find ${OUT_DIR}/dwarf -type f -exec sed -i "s_\"cmd/internal/obj_\"${BASE_PKG_PATH}/obj_g" {} \;
find ${OUT_DIR}/dwarf -type f -exec sed -i "s_\"cmd/internal/src_\"${BASE_PKG_PATH}/src_g" {} \;
find ${OUT_DIR}/dwarf -type f -exec sed -i "s_\"internal/buildcfg_\"${BASE_PKG_PATH}/buildcfg_g" {} \;

# Move src package
echo "Processing src package..."
cp -rv ${TMP_PATH}/go/src/cmd/internal/src ${OUT_DIR}/src

# Move sys package
echo "Processing sys package..."
cp -rv ${TMP_PATH}/go/src/cmd/internal/sys ${OUT_DIR}/sys
find ${OUT_DIR}/sys -type f -exec sed -i "s_\"internal/goarch_\"${BASE_PKG_PATH}/goarch_g" {} \;

# NEW: Move buildcfg package (Go 1.25 addition)
echo "Processing buildcfg package..."
cp -rv ${TMP_PATH}/go/src/internal/buildcfg ${OUT_DIR}/buildcfg
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s_\"internal/buildcfg_\"${BASE_PKG_PATH}/buildcfg_g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s_\"internal/goexperiment_\"${BASE_PKG_PATH}/goexperiment_g" {} \;

# NEW: Move internal/abi package (Go 1.25 dependency)
echo "Processing abi package..."
cp -rv ${TMP_PATH}/go/src/internal/abi ${OUT_DIR}/abi
find ${OUT_DIR}/abi -type f -exec sed -i "s_\"internal/abi_\"${BASE_PKG_PATH}/abi_g" {} \;
find ${OUT_DIR}/abi -type f -exec sed -i "s_\"internal/goarch_\"${BASE_PKG_PATH}/goarch_g" {} \;

# NEW: Move internal/goarch package (Go 1.25 dependency)
echo "Processing goarch package..."
cp -rv ${TMP_PATH}/go/src/internal/goarch ${OUT_DIR}/goarch
find ${OUT_DIR}/goarch -type f -exec sed -i "s_\"internal/goarch_\"${BASE_PKG_PATH}/goarch_g" {} \;

# NEW: Move internal/goexperiment package (Go 1.25 dependency)
echo "Processing goexperiment package..."
cp -rv ${TMP_PATH}/go/src/internal/goexperiment ${OUT_DIR}/goexperiment
find ${OUT_DIR}/goexperiment -type f -exec sed -i "s_\"internal/goexperiment_\"${BASE_PKG_PATH}/goexperiment_g" {} \;

# NEW: Move cmd/internal/hash package (Go 1.25 dependency)
echo "Processing hash package..."
cp -rv ${TMP_PATH}/go/src/cmd/internal/hash ${OUT_DIR}/hash
find ${OUT_DIR}/hash -type f -exec sed -i "s_\"cmd/internal/hash_\"${BASE_PKG_PATH}/hash_g" {} \;

# NEW: Move internal/bisect package (Go 1.25 dependency)
echo "Processing bisect package..."
cp -rv ${TMP_PATH}/go/src/internal/bisect ${OUT_DIR}/bisect
find ${OUT_DIR}/bisect -type f -exec sed -i "s_\"internal/bisect_\"${BASE_PKG_PATH}/bisect_g" {} \;

# Rewrite identifiers for generated (at build time) constants in objabi
echo "Rewriting build-time constants in objabi..."
find ${OUT_DIR}/objabi -type f -exec sed -i "s/stackGuardMultiplierDefault/1/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGOOS/\"linux\"/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGOARCH/\"$(go env GOARCH)\"/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGO386/\"\"/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGOARM/\"7\"/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGOMIPS64/\"hardfloat\"/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGOMIPS/\"hardfloat\"/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGOPPC64/\"power8\"/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGO_LDSO/\"\"/g" {} \;
# More specific replacement for version variable assignment
find ${OUT_DIR}/objabi -type f -exec sed -i "s/\bversion\b/\"\"/g" {} \;
find ${OUT_DIR}/objabi -type f -exec sed -i "s/defaultGO_EXTLINK_ENABLED/\"\"/g" {} \;
# More specific replacement for goexperiment in context
find ${OUT_DIR}/objabi -type f -exec sed -i "s/\bgoexperiment\b/\"\"/g" {} \;

# NEW: Rewrite build-time constants in buildcfg
echo "Rewriting build-time constants in buildcfg..."
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/defaultGOARCH/\"$(go env GOARCH)\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/defaultGOOS/\"linux\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGORISCV64/\"rva20u64\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGOFIPS140/\"off\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGO386/\"\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/defaultGO_LDSO/\"\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/= version/= \"\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGOAMD64/\"v1\"/g" {} \;
# IMPORTANT: Replace DefaultGOARM64 BEFORE DefaultGOARM to avoid substring conflicts
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGOARM64/\"v8.0\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGOARM/\"7\"/g" {} \;
# IMPORTANT: Replace DefaultGOMIPS64 BEFORE DefaultGOMIPS to avoid substring conflicts
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGOMIPS64/\"hardfloat\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGOMIPS/\"hardfloat\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/DefaultGOPPC64/\"power8\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/defaultGO_EXTLINK_ENABLED/\"\"/g" {} \;
find ${OUT_DIR}/buildcfg -type f -exec sed -i "s/defaultGOEXPERIMENT/\"\"/g" {} \;

# Remove tests (they have package dependencies we could do without)
echo "Removing test files..."
find ${OUT_DIR} -name "*_test.go" -type f -delete

echo "Generation complete!"