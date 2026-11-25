<h1 align="center">CONN preprocessing</h1>

<p align="center">
  fMRI preprocessing via CONN
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/bl.app.54"><img src="https://img.shields.io/badge/Brainlife-bl.app.54-blue.svg" alt="Run on brainlife.io"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **fMRI preprocessing via CONN**

| | |
|---|---|
| **Inputs** | `neuro/func/task` · `neuro/anat/t1w` |
| **Outputs** | `raw` |
| **Resources** | 12 CPUs |
| **Run it** | [doi.org/10.25663/bl.app.54](https://doi.org/10.25663/bl.app.54) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `0` | `neuro/func/task` | yes |  |
| `1` | `neuro/anat/t1w` | yes |  |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `0` | `raw` |  |

<details>
<summary><b>Parameters</b> (7)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `filter_bandpass_min` | number | `0.01` |  |
| `filter_bandpass_max` | number | `0.1` |  |
| `steps` | enum | `default_mni` | Data preprocessing steps to perform Options: `default_mni`, `default_mniphase`, `default_ss`, `default_ssphase`, `default_ssnl`. |
| `sliceorder` | enum | `ascending` | When DICOM images are converted to nifti, the slice order may not be preserved. This parameter tells CONN how slices within nifti is ordered. Options: `ascending`, `descending`, `interleaved (middle-top)`, `interleaved (bottom-up)`, `interleaved (top-down)`, `interleaved (Siemens)`, `BIDS`. |
| `do_global_signal_regression` | boolean | `true` | Do global signal regression |
| `tr` | integer | `2` |  |
| `fwhm` | integer | `8` | Edit me |

</details>

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/bl.app.54](https://doi.org/10.25663/bl.app.54), choose `neuro/func/task`, `neuro/anat/t1w` from your project, set the parameters and press **Execute**. The results are saved to your project as `raw`.

### Locally

You need [`jq`](https://jqlang.github.io/jq/).

1. Clone this repository.
2. Create `config.json` with the paths to your inputs and the parameters:

   ```json
   {
       "bold": "/path/to/0/bold",
       "t1": "/path/to/1/t1",
       "filter_bandpass_min": 0.01,
       "filter_bandpass_max": 0.1,
       "steps": "default_mni",
       "sliceorder": "ascending",
       "do_global_signal_regression": true,
       "tr": 2,
       "fwhm": 8
   }
   ```

3. Run `./main`.

## Citing

If you use this App, please cite it, the software it builds on and brainlife.io:

- CONN preprocessing. brainlife.io App. [doi:10.25663/bl.app.54](https://doi.org/10.25663/bl.app.54)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

Maintained by [@soichih](https://github.com/soichih).
