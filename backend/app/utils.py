from datetime import timedelta

def predict_next_period(start_dates):
    cycle_lengths = [(start_dates[i] - start_dates[i-1]).days for i in range(1, len(start_dates))]
    avg_cycle = sum(cycle_lengths) / len(cycle_lengths)
    next_start = start_dates[-1] + timedelta(days=avg_cycle)
    return next_start.isoformat()