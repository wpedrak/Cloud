#### 4
###### serverless
* serverlss.yaml (ustawienia i routy w jednym miejscu)
* functions in one file
* invoke function via serverless call
* access to basic logs from cli
* deployment with one command

###### nuclio
How it works?
Controller and dashboard containers in kubernetes. Controller is backend, while dashbord is frontend.

* functions in one file
* invoke function via nuclio call
* access to basic logs from cli
* deployment with one command
* **support for kubernetes**
* *but is more complicated than serverless*

#### 5
ETL (extract, transform, load). Used for:
* Data cleaning
* Gathering data from various sources

- Lambdas, we can use lamdas (probably + S3 or some kind of storage)

* AWS Glue:
  * Define sources, targets and generate code for it
  * include your own transformations
  * obviously: osom support for RDS, S3, Redshift and privat DB on EC2

* Skyvia:
  * no code
  * example data sources: AWS RDS, Redshift, Google, BigQuery, regular DB
  * more data sources: jira, slack, wordpress, google apps

#### 6
* generating of rotated secrets in AWS Secrets Manager (example in postgres)
  * switch ->
  * create new password
  * set password in DB
  * test if it works
  * change state from pending to current
* triggering jenkins build after push to git
  * lambda triggered by commit to codecommit
  * poke jenkins via http to start build

#### 9
###### Redshift vs clasic DB
* Redshift is faster (parallel)
* Redshift compress data by default (encoding)
* Can be scaled horizontally!!!

###### Data warehouse vs data lake
|                 | Data Lake                             | Data Warehouse                              |
|-----------------|---------------------------------------|---------------------------------------------|
| Data Structure  | Raw                                   | Processed                                   |
| Purpose of Data | Not Yet Determined                    | Currently In Use                            |
| Users           | Data Scientists                       | Business Professionals                      |
| Accessibility   | Highly accessible and quick to update | More complicated and costly to make changes |