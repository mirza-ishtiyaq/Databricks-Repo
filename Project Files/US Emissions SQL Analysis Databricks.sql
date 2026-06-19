# Databricks notebook source
# MAGIC %sql
# MAGIC SELECT 
# MAGIC     latitude,
# MAGIC     longitude,
# MAGIC     `GHG emissions mtons CO2e`as emissions
# MAGIC FROM `emissions`.`default`.`emissions_data`
# MAGIC LIMIT 10;

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT 
# MAGIC     county_state_name,
# MAGIC     population,
# MAGIC     CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS double) / population AS emissions_per_person
# MAGIC FROM `emissions`.`default`.`emissions_data`
# MAGIC ORDER BY emissions_per_person DESC
# MAGIC LIMIT 10;

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT 
# MAGIC     state_abbr,
# MAGIC     sum(CAST(
# MAGIC         REPLACE(
# MAGIC             `GHG emissions mtons CO2e`, ',', '') AS double
# MAGIC             )) AS Total_emissions
# MAGIC FROM `emissions`.`default`.`emissions_data`
# MAGIC GROUP BY state_abbr
# MAGIC ORDER BY Total_emissions DESC
# MAGIC LIMIT 10;

# COMMAND ----------

# MAGIC %sql
# MAGIC WITH state_emissions AS (
# MAGIC     SELECT 
# MAGIC         state_abbr,
# MAGIC         SUM(CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS double)) AS total_emissions
# MAGIC     FROM `emissions`.`default`.`emissions_data`
# MAGIC     GROUP BY state_abbr
# MAGIC ),
# MAGIC country_total AS (
# MAGIC     SELECT SUM(total_emissions) AS total_country_emissions
# MAGIC     FROM state_emissions
# MAGIC )
# MAGIC SELECT 
# MAGIC     FORMAT_NUMBER(s.total_emissions, 0) AS total_emissions_mtons,
# MAGIC     CONCAT(ROUND((s.total_emissions / c.total_country_emissions) * 100, 2), '%') AS pct_of_total_emissions
# MAGIC FROM state_emissions s
# MAGIC CROSS JOIN country_total c
# MAGIC ORDER BY s.total_emissions DESC
# MAGIC LIMIT 10;

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT
# MAGIC     county_state_name,
# MAGIC     population,
# MAGIC     cast(replace(`GHG emissions mtons CO2e`, ',', '') as double) as Total_emissions
# MAGIC from `emissions`.`default`.`emissions_data`
# MAGIC ORDER BY total_emissions DESC
# MAGIC LIMIT 10;
# MAGIC
