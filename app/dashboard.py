"""Streamlit command center: the agent's live state, one screen."""
import json
import urllib.request

import pandas as pd
import streamlit as st

"""Streamlit command center: the agent's live state, one screen."""
import json
import os
import urllib.request

import pandas as pd
import streamlit as st


def _api_base():
    try:
        if "REVIVE_API" in st.secrets:
            return st.secrets["REVIVE_API"]
    except Exception:
        pass
    return os.environ.get("REVIVE_API", "http://127.0.0.1:8000")


API = _api_base()

def get(path):
    with urllib.request.urlopen(API + path) as r:
        return json.loads(r.read())

st.set_page_config(page_title="Revive AI", layout="wide")
st.title("Revive AI — Recovery Command Center")
st.caption("Consent-first recovery · RBI-aware · every decision audit-logged")

try:
    ov = get("/api/overview")
except Exception:
    st.error("API not reachable — start it first: uvicorn app.main:app --reload")
    st.stop()

c1, c2, c3, c4 = st.columns(4)
c1.metric("Failures", ov["failures_total"])
c2.metric("At risk", f"Rs.{ov['amount_at_risk_rupees']:,.0f}")
c3.metric("Recovered", f"Rs.{ov['amount_recovered_rupees']:,.0f}")
c4.metric("Protected", f"Rs.{ov['amount_protected_rupees']:,.0f}")

colA, colB = st.columns(2)
with colA:
    st.subheader("Consent Gate verdicts")
    st.bar_chart(pd.Series(ov["verdicts"], name="count"))
with colB:
    st.subheader("Diagnosis archetypes")
    st.bar_chart(pd.Series(ov["archetypes"], name="count"))

st.subheader("Blocked retries — the conscience at work")
st.dataframe(pd.DataFrame(get("/api/failures?verdict=BLOCK&limit=15")),
             use_container_width=True)

st.subheader("Merchant compliance (RBI mandates)")
st.dataframe(pd.DataFrame(get("/api/merchants")), use_container_width=True)

st.subheader("Queued salary-day jobs")
st.dataframe(pd.DataFrame(get("/api/jobs")), use_container_width=True)

st.subheader("Audit trail")
st.dataframe(pd.DataFrame(get("/api/audit")), use_container_width=True)