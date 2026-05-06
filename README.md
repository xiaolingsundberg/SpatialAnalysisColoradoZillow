# Spatial Analysis of Colorado Zillow Housing Listings

This repository contains the final semester project for STA6709 Spatial Statistics. The project analyzes Colorado Zillow listing data using spatial mapping, exploratory summaries, regression modeling, nearest-neighbor analysis, clustering, and presentation-ready reporting.

## Project Contents

```text
SemesterProject/
  CODE/
    STA6709_complete_spatial_project.R
    create_spatial_project_presentation.py
  WRITE UP/
    STA6709_Revised_Write_Up.pdf
    STA6709_Colorado_Zillow_Spatial_Analysis_Presentation.pptx
```

## Files

- `STA6709_complete_spatial_project.R`: Main R analysis script for data cleaning, spatial mapping, regression, nearest-neighbor analysis, clustering, and visualization.
- `create_spatial_project_presentation.py`: Python script used to generate the PowerPoint presentation.
- `STA6709_Revised_Write_Up.pdf`: Long-form final report.
- `STA6709_Colorado_Zillow_Spatial_Analysis_Presentation.pptx`: Final project slide deck.

## Methods Used

- Spatial point mapping with latitude and longitude
- Colorado state and county boundary overlays
- Exploratory price and housing characteristic summaries
- Log-price regression modeling
- Nearest-neighbor distance analysis
- Spatial clustering analysis
- Static and presentation-ready visualizations

## Note on Data

The raw Zillow CSV file is not included in this repository. The R script expects the data file at:

```text
SemesterProject/DATA/colorado_zillow.csv
```

To rerun the full analysis, place the source CSV at that path or update the `data_dir` path in the R script.

## Author

Xiaoling Sundberg  
STA6709 Spatial Statistics  
May 2026
