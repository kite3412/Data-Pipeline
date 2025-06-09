## Description
This is a group project that built a simple data pipeline that ingest the Brazilian E-commerce dataset from Kaggle into DuckDB, transformed the dataset into star schema using dbt, validate the transformed data using dbt utils and dbt expectations, use the star schema for data visualisation to produce meaningful insights.

## Contribution
Special thanks to Hugo, Stewart, Wang Jing and Rubiyah for their contributions to this project.

## Project Structure
```
Data-Pipeline/
├── OLIST/                      # Contains the Brazilian E-commerce csv files downloaded from Kaggle
├── olist_project/              # dbt folder, cd into this folder to run dbt commands 
├── data_ingestion.py           # Ingest data from the csv files into DuckDB
├── Documentation.pptx          # Detailed documentation for this project
├── environment.yml             # Conda environment
├── olist_data_analysis.ipynb   # Jupyter notebook for data visualization
└── requirements.txt            # Necessary packages
```

## Setup
1. Clone the repository: `git clone https://github.com/kite3412/Data-Pipeline`

2. Create the conda environment: `conda env create -f environment.yml`

3. Activate the conda environment: `conda activate group2`

4. Intall the dependecies: `pip install -r requirements.txt`
 
## Running the Pipeline
1. Run **data_ingestion.py** to create a database file 

2. `cd` into olist_project folder

3. Run `dbt deps` to install dbt dependencies

4. Run `dbt run` to transform the data

5. Run `dbt test` to validate the transformed data

6. Run olist_data_analysis for data visualisation (kernel:group2)

7. View the database file **olist.db** through DuckDB connection in DBeaver

## Contact
Feel free to contact me at jinbowen3412@gmail.com if you have any question regarding this project.

Check out my LinkedIn page at https://www.linkedin.com/in/jin-bowen-548992340/
