# 524-Final-Project
## Pipeline Documentation
### Completeness

This project consists of five key pipeline components:

1. **Data Input**  
Users interact with the Shiny interface to select a country, a health indicator, and a time range.

2. **Data Retrieval**  
Data is retrieved in real time from the World Bank API using HTTP requests based on user input.

3. **Data Processing**  
The retrieved data is cleaned by converting variables to numeric format, filtering out missing values, and sorting observations by year.

4. **Analysis**  
Summary statistics, including mean, minimum, and maximum values, are computed. Temporal trends are analyzed by comparing the first and last observations.

5. **Interpretation**  
A rule-based interpretation module generates natural language summaries describing whether the selected indicator shows an increasing, decreasing, or stable trend over time.


### Reproducibility

This project is fully reproducible. To run the application:

1. Install the required R packages:
   - `shiny`
   - `httr`
   - `jsonlite`
   - `dplyr`
   - `ggplot2`

2. Open the R script containing the application code.

3. Run the script in R or RStudio to launch the Shiny application locally.

No additional configuration or external API keys are required, as the World Bank API is publicly accessible.



### Clarity

The code is organized into clearly defined sections, including data retrieval, processing, analysis, interpretation, user interface (UI), and server logic. Each section is labeled with comments to improve readability and maintainability.

The modular structure of the code ensures that each component of the pipeline is easy to understand and can be modified independently. This design also improves robustness and avoids dependency on external AI services.
