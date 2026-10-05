from datasets import load_dataset

ds = load_dataset("vblagoje/cc_news", split="train")

per_day = (
    ds.select_columns(["date"])
    .to_pandas()["date"]
    .astype(str)
    .str[:10]
    .value_counts()
    .sort_index()
)
print(per_day)
