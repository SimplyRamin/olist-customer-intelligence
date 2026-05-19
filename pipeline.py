# =================================================================================================
#                                           Written by Ramin F.
#                                      AI Engineer & Data Scientist
#                            Ferdos.ramin@gmail.com | simplyramin.github.io
# =================================================================================================

from prefect import task, flow
import subprocess
import duckdb

@task(log_prints=True)
def run_dbt_pipeline():
    """Run the full dbt transformation pipeline"""
    result = subprocess.run(
        ["uv", "run", "dbt", "run", "--profiles-dir", "."],
        cwd="olist_pipeline",
        capture_output=True,
        text=True
    )
    print(result.stdout)
    if result.returncode != 0:
        raise Exception(f"dbt pipeline failed:\n{result.stderr}")
    return "dbt pipeline completed"

@task(log_prints=True)
def run_dbt_tests():
    """Run data quality tests"""
    result = subprocess.run(
        ["uv", "run", "dbt", "test", "--profiles-dir", "."],
        cwd="olist_pipeline",
        capture_output=True,
        text=True
    )
    print(result.stdout)
    if result.returncode != 0:
        raise Exception(f"dbt tests failed:\n{result.stderr}")
    return "all tests passed"

@task(log_prints=True)
def validate_feature_table():
    """Validate the final feature for table has expected data"""
    con = duckdb.connect('data/olist.db')
    row_count = con.execute(
        "SELECT COUNT(*) FROM customer_features"
    ).fetchone()[0]
    print(f"customer_features: {row_count:,} rows")
    if row_count < 90_000:
        raise Exception(f"Row count too low: {row_count}")
    return f"Validation passed: {row_count:,} rows"

@flow(name="olist-feature-pipeline")
def olist_pipeline():
    """
    Complete Olist feature engineering pipeline:
    1. Run dbt transformations
    2. Run data quality tests
    3. Validate output table
    """
    dbt_result = run_dbt_pipeline()
    test_result = run_dbt_tests(wait_for=[dbt_result])
    validation = validate_feature_table(wait_for=[test_result])
    return validation

if __name__ == "__main__":
    olist_pipeline()