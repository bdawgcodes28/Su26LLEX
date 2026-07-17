## Librelane for MPW (multi-project wafer)

This repository is meant to serve as a template for multi-project wafer (MPW) designs.
It is similar to the initial tutorial where you learned how to run the Librelane flow. If
you have not gone through that tutorial please visit the directory root.

## What to Expect

This tutorial will detail running the Librelane flow on RTL (Register Transfer Level) designs
for MPW projects. It is similar to the initial tutorial, as it uses the same test SRAM macro,
but instantiates two of them in the caravel user-project wrapper.

The SRAM design can be found [here](https://github.com/efabless/openlane2-ci-designs/tree/main/test_sram_macro)

## Getting Started

Before you start, make sure you are in a Nix shell. Enter the Nix shell using the following
in the project root

```bash
nix-shell shell.nix
```

Once you are in the Nix shell, navigate back to the mpw_template directory

```bash
cd librelane/examples/mpw_template
```

### File Structure

See the following diagram to view the file structure of this directory:

```text
mpw_template/
├── Design 1/
|	├── config.json
|	├── blackbox Verilog file (.bb.v)
|	├── macro_placement.cfg (maps SRAM cells in macro)
|	├── src/
|		├── Verilog design file (.v)
└── Design 2/
|	├── config.json
|	├── blackbox Verilog file (.bb.v)
|	├── macro_placement.cfg (maps SRAM cells in macro)
|	├── src/
|		├── Verilog design file (.v)
└── Wrapper/
|	├── config.json
|	├── macro_placement.cfg (maps SRAM macros in caravel wrapper)
|	├── base_user_project_wrapper.sdc (standard caravel file)
|	├── blackbox Verilog file (.bb.v)
|	├── fixed_dont_change/
|		├── user_project_wrapper.def (standard caravel file)
|	├── src/
|		├── defines.v
|		├── user_project_wrapper.v
```

This file structure is pertains only to this tutorial. When you begin developing you own
projects, a more typical file structure may look like the following:

```
mpw_template/
├── Design 1/
|	├── config.json
|	├── src/
|		├── Verilog design file (.v)
└── Design 2/
|	├── config.json
|	├── src/
|		├── Verilog design file (.v)
└── Wrapper/
|	├── config.json
|	├── macro_placement.cfg (maps SRAM macros in caravel wrapper)
|	├── base_user_project_wrapper.sdc (standard caravel file)
|	├── blackbox Verilog file (.bb.v)
|	├── fixed_dont_change/
|		├── user_project_wrapper.def (standard caravel file)
|	├── src/
|		├── defines.v
|		├── user_project_wrapper.v
```

### Running Librelane Flow

You will need to harden each SRAM macro separately before hardening the wrapper.

```bash
cd test_sram_macro
librelane config.json
```

```bash
cd test_sram_macrox2
librelane config.json
```

Once each design is hardened, you may move forward by hardening the wrapper.

```bash
cd wrapper
librelane config.json
```

Note: it will take ~20 minutes for the flow to finish running. Additionally, you will
encounter some DRC and LVS errors. This tutorial serves as proof of concept and does
NOT produce a signoff ready design. Projects you start using this tutorial will not
necessarily encounter these errors.

## Viewing Results

Once the flow completes a runs folder will populate in the wrapper directory. Navigate through
this directory into the "final" directory.

### Klayout

To view the hardened wrapper in Klayout run the following:

```bash
cd klayout_gds
klayout user_project_wrapper.klayout.gds
```

See below for results:

![SRAM macros instantiated in Wrapper](../../images/Klayout-SRAM-Wrapper)

### OpenROAD GUI

To view the hardened wrapper in the OpenROAD GUI run the following:

```bash
cd odb
openroad
read_db user_project_wrapper.odb
gui::show
```

See below for results

![SRAM macros instantiated in Wrapper](../../images/OpenROAD-SRAM-Wrapper)
