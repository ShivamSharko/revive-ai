--
-- PostgreSQL database dump
--

\restrict A9Uzfmw2wQNfl9M127kla8Oi6lVequnUoNhqyiSh2cnXpHC8rBPkFcOSZggYpF2

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    entity_type character varying(32),
    entity_id integer,
    actor character varying(8),
    action character varying(64),
    reasoning text,
    metadata_json json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: customer_payment_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_payment_history (
    id integer NOT NULL,
    customer_id character varying(64),
    day_of_month integer,
    amount_paise bigint,
    status character varying(16)
);


ALTER TABLE public.customer_payment_history OWNER TO postgres;

--
-- Name: customer_payment_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_payment_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_payment_history_id_seq OWNER TO postgres;

--
-- Name: customer_payment_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_payment_history_id_seq OWNED BY public.customer_payment_history.id;


--
-- Name: diagnoses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diagnoses (
    id integer NOT NULL,
    failure_id integer,
    archetype character varying(24),
    owner character varying(24),
    confidence double precision,
    reasoning text,
    model_used character varying(32),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.diagnoses OWNER TO postgres;

--
-- Name: diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diagnoses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diagnoses_id_seq OWNER TO postgres;

--
-- Name: diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diagnoses_id_seq OWNED BY public.diagnoses.id;


--
-- Name: gate_decisions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gate_decisions (
    id integer NOT NULL,
    failure_id integer,
    rule_id character varying(32) NOT NULL,
    verdict character varying(16) NOT NULL,
    context_snapshot json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.gate_decisions OWNER TO postgres;

--
-- Name: gate_decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gate_decisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gate_decisions_id_seq OWNER TO postgres;

--
-- Name: gate_decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gate_decisions_id_seq OWNED BY public.gate_decisions.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    failure_id integer,
    kind character varying(32),
    run_at timestamp with time zone,
    attempts integer,
    max_attempts integer,
    status character varying(16),
    last_error text
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: merchant_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.merchant_config (
    id integer NOT NULL,
    merchant_id character varying(64),
    pre_debit_notification_hours integer,
    billing_day integer,
    fee_reveal_at_checkout boolean
);


ALTER TABLE public.merchant_config OWNER TO postgres;

--
-- Name: merchant_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.merchant_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.merchant_config_id_seq OWNER TO postgres;

--
-- Name: merchant_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.merchant_config_id_seq OWNED BY public.merchant_config.id;


--
-- Name: payment_failures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_failures (
    id integer NOT NULL,
    external_payment_id character varying(64),
    source character varying(16),
    amount_paise bigint NOT NULL,
    currency character varying(8),
    method character varying(32),
    failure_code character varying(64),
    failure_description text,
    customer_id character varying(64),
    merchant_id character varying(64),
    context character varying(32),
    session_active boolean,
    dropped_step character varying(32),
    archetype character varying(24),
    owner character varying(24),
    confidence double precision,
    true_archetype character varying(24),
    true_owner character varying(24),
    status character varying(24),
    amount_recovered_paise bigint,
    amount_protected_paise bigint,
    occurred_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.payment_failures OWNER TO postgres;

--
-- Name: payment_failures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_failures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_failures_id_seq OWNER TO postgres;

--
-- Name: payment_failures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_failures_id_seq OWNED BY public.payment_failures.id;


--
-- Name: promises_to_pay; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promises_to_pay (
    id integer NOT NULL,
    failure_id integer,
    promised_date timestamp with time zone NOT NULL,
    amount_paise bigint NOT NULL,
    status character varying(16),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.promises_to_pay OWNER TO postgres;

--
-- Name: promises_to_pay_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promises_to_pay_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promises_to_pay_id_seq OWNER TO postgres;

--
-- Name: promises_to_pay_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promises_to_pay_id_seq OWNED BY public.promises_to_pay.id;


--
-- Name: recovery_actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recovery_actions (
    id integer NOT NULL,
    failure_id integer,
    action_type character varying(32),
    actor character varying(8),
    reasoning text,
    status character varying(16),
    amount_recovered_paise bigint,
    executed_at timestamp with time zone
);


ALTER TABLE public.recovery_actions OWNER TO postgres;

--
-- Name: recovery_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recovery_actions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recovery_actions_id_seq OWNER TO postgres;

--
-- Name: recovery_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recovery_actions_id_seq OWNED BY public.recovery_actions.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: customer_payment_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_payment_history ALTER COLUMN id SET DEFAULT nextval('public.customer_payment_history_id_seq'::regclass);


--
-- Name: diagnoses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diagnoses ALTER COLUMN id SET DEFAULT nextval('public.diagnoses_id_seq'::regclass);


--
-- Name: gate_decisions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_decisions ALTER COLUMN id SET DEFAULT nextval('public.gate_decisions_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: merchant_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_config ALTER COLUMN id SET DEFAULT nextval('public.merchant_config_id_seq'::regclass);


--
-- Name: payment_failures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_failures ALTER COLUMN id SET DEFAULT nextval('public.payment_failures_id_seq'::regclass);


--
-- Name: promises_to_pay id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promises_to_pay ALTER COLUMN id SET DEFAULT nextval('public.promises_to_pay_id_seq'::regclass);


--
-- Name: recovery_actions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_actions ALTER COLUMN id SET DEFAULT nextval('public.recovery_actions_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, entity_type, entity_id, actor, action, reasoning, metadata_json, created_at) FROM stdin;
1	failure	1	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
2	failure	2	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
3	failure	3	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
4	failure	4	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
5	failure	5	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
6	failure	6	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
7	failure	7	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
8	failure	8	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
9	failure	9	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
10	failure	10	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
11	failure	11	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
12	failure	12	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
13	failure	13	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
14	failure	14	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
15	failure	15	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
16	failure	16	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
17	failure	17	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
18	failure	18	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
19	failure	19	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
20	failure	20	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
21	failure	21	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
22	failure	22	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
23	failure	23	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
24	failure	24	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
25	failure	25	system	BLOCK:R07_OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-25 22:12:52.883864+00
26	failure	26	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
27	failure	27	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
28	failure	28	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
29	failure	29	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
30	failure	30	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
31	failure	31	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
32	failure	32	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
33	failure	33	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
34	failure	34	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
35	failure	35	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
36	failure	36	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
37	failure	37	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
38	failure	38	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
39	failure	39	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
40	failure	40	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
41	failure	41	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
42	failure	42	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
43	failure	43	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
44	failure	44	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
45	failure	45	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
46	failure	46	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
47	failure	47	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
48	failure	48	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
49	failure	49	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
50	failure	50	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
51	failure	51	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
52	failure	52	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
53	failure	53	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
54	failure	54	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
55	failure	55	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
56	failure	56	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
57	failure	57	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
58	failure	58	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
59	failure	59	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
60	failure	60	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
61	failure	61	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
62	failure	62	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
63	failure	63	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
64	failure	64	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
65	failure	65	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
66	failure	66	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 15 (conf 1.0), histogram {15: 8}. Defer to day 15.	\N	2026-08-25 22:12:52.883864+00
67	failure	67	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
68	failure	68	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
69	failure	69	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
70	failure	70	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
71	failure	71	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
72	failure	72	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
73	failure	73	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
74	failure	74	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
75	failure	75	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
76	failure	76	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
77	failure	77	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
78	failure	78	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
79	failure	79	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
80	failure	80	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
81	failure	81	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
82	failure	82	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
83	failure	83	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
84	failure	84	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
85	failure	85	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
86	failure	86	system	BLOCK:R07_OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-25 22:12:52.883864+00
87	failure	87	system	BLOCK:R07_OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-25 22:12:52.883864+00
88	failure	88	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
89	failure	89	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
90	failure	90	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
91	failure	91	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
92	failure	92	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
93	failure	93	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
94	failure	94	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
95	failure	95	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
96	failure	96	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
97	failure	97	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
98	failure	98	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
99	failure	99	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
100	failure	100	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
101	failure	101	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
102	failure	102	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
103	failure	103	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
104	failure	104	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
105	failure	105	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
106	failure	106	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
107	failure	107	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
108	failure	108	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
109	failure	109	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
110	failure	110	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
111	failure	111	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
112	failure	112	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
113	failure	113	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
114	failure	114	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
115	failure	115	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
116	failure	116	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
117	failure	117	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
118	failure	118	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
119	failure	119	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
120	failure	120	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
121	failure	121	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
122	failure	122	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
123	failure	123	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
124	failure	124	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
125	failure	125	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
126	failure	126	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
127	failure	127	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
128	failure	128	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
129	failure	129	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
130	failure	130	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
131	failure	131	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
132	failure	132	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
133	failure	133	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
134	failure	134	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
135	failure	135	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
136	failure	136	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
137	failure	137	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
138	failure	138	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
139	failure	139	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
140	failure	140	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
141	failure	141	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
142	failure	142	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
143	failure	143	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
144	failure	144	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
145	failure	145	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
146	failure	146	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
147	failure	147	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
148	failure	148	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
149	failure	149	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
150	failure	150	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
151	failure	151	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
152	failure	152	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
153	failure	153	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
154	failure	154	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
155	failure	155	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 15 (conf 1.0), histogram {15: 8}. Defer to day 15.	\N	2026-08-25 22:12:52.883864+00
156	failure	156	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
157	failure	157	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
158	failure	158	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
159	failure	159	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
160	failure	160	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
161	failure	161	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
162	failure	162	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
163	failure	163	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
164	failure	164	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
165	failure	165	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
166	failure	166	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
167	failure	167	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
168	failure	168	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
169	failure	169	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
170	failure	170	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
171	failure	171	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
172	failure	172	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
173	failure	173	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
174	failure	174	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
175	failure	175	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
176	failure	176	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
177	failure	177	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
178	failure	178	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
179	failure	179	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
180	failure	180	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
181	failure	181	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
182	failure	182	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
183	failure	183	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
184	failure	184	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
185	failure	185	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
186	failure	186	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
187	failure	187	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
188	failure	188	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
189	failure	189	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 15 (conf 1.0), histogram {15: 8}. Defer to day 15.	\N	2026-08-25 22:12:52.883864+00
190	failure	190	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
191	failure	191	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
192	failure	192	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
193	failure	193	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
194	failure	194	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
195	failure	195	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
196	failure	196	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
197	failure	197	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
198	failure	198	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
199	failure	199	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
200	failure	200	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
201	failure	201	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
202	failure	202	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
203	failure	203	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
204	failure	204	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
205	failure	205	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
206	failure	206	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
207	failure	207	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
208	failure	208	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
209	failure	209	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
210	failure	210	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
211	failure	211	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 15 (conf 1.0), histogram {15: 8}. Defer to day 15.	\N	2026-08-25 22:12:52.883864+00
212	failure	212	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
213	failure	213	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
214	failure	214	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
215	failure	215	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
216	failure	216	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
217	failure	217	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
218	failure	218	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
219	failure	219	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
220	failure	220	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
221	failure	221	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
222	failure	222	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
223	failure	223	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
224	failure	224	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
225	failure	225	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
226	failure	226	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
227	failure	227	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
228	failure	228	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
229	failure	229	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
230	failure	230	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
231	failure	231	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
232	failure	232	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
233	failure	233	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
234	failure	234	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
235	failure	235	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
236	failure	236	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
237	failure	237	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
238	failure	238	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
239	failure	239	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
240	failure	240	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
241	failure	241	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
242	failure	242	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
243	failure	243	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
244	failure	244	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
245	failure	245	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
246	failure	246	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
247	failure	247	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
248	failure	248	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
249	failure	249	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
250	failure	250	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
251	failure	251	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
252	failure	252	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
253	failure	253	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
254	failure	254	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
255	failure	255	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
256	failure	256	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
257	failure	257	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
258	failure	258	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
259	failure	259	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
260	failure	260	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
261	failure	261	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
262	failure	262	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
263	failure	263	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
264	failure	264	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
265	failure	265	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
266	failure	266	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
267	failure	267	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
268	failure	268	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
269	failure	269	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
270	failure	270	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
271	failure	271	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
272	failure	272	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
273	failure	273	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
274	failure	274	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
275	failure	275	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
276	failure	276	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
277	failure	277	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
278	failure	278	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
279	failure	279	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
280	failure	280	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
281	failure	281	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
282	failure	282	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
283	failure	283	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
284	failure	284	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
285	failure	285	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
286	failure	286	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
287	failure	287	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
288	failure	288	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 15 (conf 1.0), histogram {15: 8}. Defer to day 15.	\N	2026-08-25 22:12:52.883864+00
289	failure	289	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
290	failure	290	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
291	failure	291	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
292	failure	292	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
293	failure	293	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
294	failure	294	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
295	failure	295	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
296	failure	296	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
297	failure	297	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
298	failure	298	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
299	failure	299	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
300	failure	300	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
301	failure	301	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
302	failure	302	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
303	failure	303	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
304	failure	304	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
305	failure	305	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
306	failure	306	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
307	failure	307	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
308	failure	308	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
309	failure	309	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
310	failure	310	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
311	failure	311	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
312	failure	312	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
313	failure	313	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
314	failure	314	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
315	failure	315	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
316	failure	316	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
317	failure	317	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
318	failure	318	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
319	failure	319	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
320	failure	320	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
321	failure	321	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
322	failure	322	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
323	failure	323	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
324	failure	324	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
325	failure	325	system	BLOCK:R07_OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-25 22:12:52.883864+00
326	failure	326	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
327	failure	327	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
328	failure	328	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
329	failure	329	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
330	failure	330	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
331	failure	331	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
332	failure	332	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
333	failure	333	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
334	failure	334	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
335	failure	335	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
336	failure	336	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
337	failure	337	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
338	failure	338	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
339	failure	339	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
340	failure	340	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
341	failure	341	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
342	failure	342	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
343	failure	343	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
344	failure	344	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
345	failure	345	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
346	failure	346	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
347	failure	347	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
348	failure	348	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
349	failure	349	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
350	failure	350	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
351	failure	351	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
352	failure	352	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
353	failure	353	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
354	failure	354	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
355	failure	355	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
356	failure	356	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
357	failure	357	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
358	failure	358	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
359	failure	359	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
360	failure	360	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
361	failure	361	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
362	failure	362	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
363	failure	363	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
364	failure	364	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
365	failure	365	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
366	failure	366	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
367	failure	367	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
368	failure	368	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
369	failure	369	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
370	failure	370	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
371	failure	371	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
372	failure	372	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
373	failure	373	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
374	failure	374	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
375	failure	375	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
376	failure	376	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
377	failure	377	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
378	failure	378	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
379	failure	379	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
380	failure	380	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
381	failure	381	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
382	failure	382	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
383	failure	383	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
384	failure	384	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
385	failure	385	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
386	failure	386	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
387	failure	387	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
388	failure	388	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
389	failure	389	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
390	failure	390	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
391	failure	391	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
392	failure	392	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
393	failure	393	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
394	failure	394	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
395	failure	395	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
396	failure	396	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
397	failure	397	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
398	failure	398	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
399	failure	399	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
400	failure	400	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
401	failure	401	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
402	failure	402	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
403	failure	403	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
404	failure	404	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
405	failure	405	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
406	failure	406	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
407	failure	407	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
408	failure	408	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
409	failure	409	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
410	failure	410	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
411	failure	411	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
412	failure	412	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
413	failure	413	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
414	failure	414	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
415	failure	415	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
416	failure	416	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
417	failure	417	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
418	failure	418	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
419	failure	419	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
420	failure	420	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
421	failure	421	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
422	failure	422	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
423	failure	423	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
424	failure	424	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
425	failure	425	system	BLOCK:R07_OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-25 22:12:52.883864+00
426	failure	426	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
427	failure	427	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
428	failure	428	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
429	failure	429	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
430	failure	430	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
431	failure	431	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
432	failure	432	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
433	failure	433	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
434	failure	434	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
435	failure	435	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
436	failure	436	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
437	failure	437	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
438	failure	438	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
439	failure	439	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
440	failure	440	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
441	failure	441	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
442	failure	442	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
443	failure	443	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
444	failure	444	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
445	failure	445	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
446	failure	446	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
447	failure	447	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
448	failure	448	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
449	failure	449	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 5 (conf 1.0), histogram {5: 8}. Defer to day 5.	\N	2026-08-25 22:12:52.883864+00
450	failure	450	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
451	failure	451	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
452	failure	452	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
453	failure	453	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
454	failure	454	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
455	failure	455	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
456	failure	456	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
457	failure	457	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
458	failure	458	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
459	failure	459	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
460	failure	460	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
461	failure	461	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
462	failure	462	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
463	failure	463	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
464	failure	464	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
465	failure	465	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
466	failure	466	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
467	failure	467	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
468	failure	468	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
469	failure	469	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
470	failure	470	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
471	failure	471	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
472	failure	472	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
473	failure	473	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
474	failure	474	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
475	failure	475	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
476	failure	476	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
477	failure	477	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
478	failure	478	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
479	failure	479	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
480	failure	480	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
481	failure	481	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
482	failure	482	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 20 (conf 1.0), histogram {20: 8}. Defer to day 20.	\N	2026-08-25 22:12:52.883864+00
483	failure	483	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
484	failure	484	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
485	failure	485	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 15 (conf 1.0), histogram {15: 8}. Defer to day 15.	\N	2026-08-25 22:12:52.883864+00
486	failure	486	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
487	failure	487	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
488	failure	488	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
489	failure	489	system	DEFER:R04_LIQUIDITY_DEFER	Liquidity curve over 8 captured payments: modal day 1 (conf 1.0), histogram {1: 8}. Defer to day 1.	\N	2026-08-25 22:12:52.883864+00
490	failure	490	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
491	failure	491	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
492	failure	492	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
493	failure	493	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
494	failure	494	system	ALLOW:R05_TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-25 22:12:52.883864+00
495	failure	495	system	BLOCK:R03_STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-25 22:12:52.883864+00
496	failure	496	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
497	failure	497	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
498	failure	498	system	BLOCK:R01_RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-25 22:12:52.883864+00
499	failure	499	system	BLOCK:R02_FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-25 22:12:52.883864+00
500	failure	500	system	ALLOW:R06_DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-25 22:12:52.883864+00
\.


--
-- Data for Name: customer_payment_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_payment_history (id, customer_id, day_of_month, amount_paise, status) FROM stdin;
1	cust_001	20	101200	captured
2	cust_001	20	30400	captured
3	cust_001	20	235300	captured
4	cust_001	20	210600	captured
5	cust_001	20	192800	captured
6	cust_001	20	124300	captured
7	cust_001	20	93900	captured
8	cust_001	20	456700	captured
9	cust_002	1	493700	captured
10	cust_002	1	355600	captured
11	cust_002	1	36000	captured
12	cust_002	1	34400	captured
13	cust_002	1	86700	captured
14	cust_002	1	189100	captured
15	cust_002	1	200500	captured
16	cust_002	1	423900	captured
17	cust_003	15	31700	captured
18	cust_003	15	469700	captured
19	cust_003	15	172800	captured
20	cust_003	15	456400	captured
21	cust_003	15	353600	captured
22	cust_003	15	190500	captured
23	cust_003	15	377900	captured
24	cust_003	15	492700	captured
25	cust_004	1	15300	captured
26	cust_004	1	140700	captured
27	cust_004	1	356200	captured
28	cust_004	1	288700	captured
29	cust_004	1	237600	captured
30	cust_004	1	137300	captured
31	cust_004	1	186300	captured
32	cust_004	1	285700	captured
33	cust_005	1	85900	captured
34	cust_005	1	321200	captured
35	cust_005	1	89200	captured
36	cust_005	1	304000	captured
37	cust_005	1	291700	captured
38	cust_005	1	226600	captured
39	cust_005	1	45500	captured
40	cust_005	1	386300	captured
41	cust_006	15	112200	captured
42	cust_006	15	320000	captured
43	cust_006	15	74500	captured
44	cust_006	15	462200	captured
45	cust_006	15	250100	captured
46	cust_006	15	306200	captured
47	cust_006	15	482900	captured
48	cust_006	15	167500	captured
49	cust_007	20	66900	captured
50	cust_007	20	47500	captured
51	cust_007	20	196600	captured
52	cust_007	20	247000	captured
53	cust_007	20	75300	captured
54	cust_007	20	200700	captured
55	cust_007	20	92700	captured
56	cust_007	20	321300	captured
57	cust_008	1	381400	captured
58	cust_008	1	308800	captured
59	cust_008	1	143200	captured
60	cust_008	1	313200	captured
61	cust_008	1	301000	captured
62	cust_008	1	181600	captured
63	cust_008	1	228700	captured
64	cust_008	1	68400	captured
65	cust_009	15	150100	captured
66	cust_009	15	447500	captured
67	cust_009	15	210500	captured
68	cust_009	15	143800	captured
69	cust_009	15	388600	captured
70	cust_009	15	320800	captured
71	cust_009	15	231100	captured
72	cust_009	15	466200	captured
73	cust_010	1	275600	captured
74	cust_010	1	55800	captured
75	cust_010	1	197600	captured
76	cust_010	1	36200	captured
77	cust_010	1	268400	captured
78	cust_010	1	338600	captured
79	cust_010	1	229300	captured
80	cust_010	1	64200	captured
81	cust_011	1	474600	captured
82	cust_011	1	267700	captured
83	cust_011	1	184100	captured
84	cust_011	1	418900	captured
85	cust_011	1	334100	captured
86	cust_011	1	385800	captured
87	cust_011	1	127000	captured
88	cust_011	1	226900	captured
89	cust_012	1	212000	captured
90	cust_012	1	469800	captured
91	cust_012	1	451500	captured
92	cust_012	1	225200	captured
93	cust_012	1	488800	captured
94	cust_012	1	360900	captured
95	cust_012	1	488000	captured
96	cust_012	1	337100	captured
97	cust_013	1	189600	captured
98	cust_013	1	123300	captured
99	cust_013	1	427400	captured
100	cust_013	1	414200	captured
101	cust_013	1	84400	captured
102	cust_013	1	48500	captured
103	cust_013	1	99800	captured
104	cust_013	1	135200	captured
105	cust_014	20	141000	captured
106	cust_014	20	355800	captured
107	cust_014	20	498500	captured
108	cust_014	20	62000	captured
109	cust_014	20	325200	captured
110	cust_014	20	322600	captured
111	cust_014	20	498100	captured
112	cust_014	20	393400	captured
113	cust_015	15	215900	captured
114	cust_015	15	463200	captured
115	cust_015	15	19400	captured
116	cust_015	15	103800	captured
117	cust_015	15	449800	captured
118	cust_015	15	228500	captured
119	cust_015	15	288600	captured
120	cust_015	15	101300	captured
121	cust_016	1	366100	captured
122	cust_016	1	139500	captured
123	cust_016	1	381600	captured
124	cust_016	1	12600	captured
125	cust_016	1	225700	captured
126	cust_016	1	420000	captured
127	cust_016	1	156300	captured
128	cust_016	1	425800	captured
129	cust_017	1	254400	captured
130	cust_017	1	425800	captured
131	cust_017	1	172900	captured
132	cust_017	1	135200	captured
133	cust_017	1	316300	captured
134	cust_017	1	142300	captured
135	cust_017	1	451800	captured
136	cust_017	1	444400	captured
137	cust_018	1	275500	captured
138	cust_018	1	410200	captured
139	cust_018	1	25900	captured
140	cust_018	1	101600	captured
141	cust_018	1	307300	captured
142	cust_018	1	261900	captured
143	cust_018	1	206100	captured
144	cust_018	1	57400	captured
145	cust_019	1	474700	captured
146	cust_019	1	74500	captured
147	cust_019	1	80100	captured
148	cust_019	1	408100	captured
149	cust_019	1	66600	captured
150	cust_019	1	446300	captured
151	cust_019	1	113000	captured
152	cust_019	1	115100	captured
153	cust_020	20	399300	captured
154	cust_020	20	460300	captured
155	cust_020	20	145200	captured
156	cust_020	20	227100	captured
157	cust_020	20	442200	captured
158	cust_020	20	356600	captured
159	cust_020	20	183500	captured
160	cust_020	20	451700	captured
161	cust_021	20	174700	captured
162	cust_021	20	265300	captured
163	cust_021	20	336800	captured
164	cust_021	20	315900	captured
165	cust_021	20	368800	captured
166	cust_021	20	433900	captured
167	cust_021	20	379800	captured
168	cust_021	20	109100	captured
169	cust_022	1	194000	captured
170	cust_022	1	62400	captured
171	cust_022	1	286900	captured
172	cust_022	1	27200	captured
173	cust_022	1	491900	captured
174	cust_022	1	463700	captured
175	cust_022	1	198500	captured
176	cust_022	1	492000	captured
177	cust_023	1	15800	captured
178	cust_023	1	68100	captured
179	cust_023	1	58200	captured
180	cust_023	1	197500	captured
181	cust_023	1	65200	captured
182	cust_023	1	35700	captured
183	cust_023	1	280600	captured
184	cust_023	1	68000	captured
185	cust_024	15	204900	captured
186	cust_024	15	238100	captured
187	cust_024	15	407600	captured
188	cust_024	15	185500	captured
189	cust_024	15	451700	captured
190	cust_024	15	118300	captured
191	cust_024	15	477700	captured
192	cust_024	15	482000	captured
193	cust_025	5	209000	captured
194	cust_025	5	397400	captured
195	cust_025	5	343400	captured
196	cust_025	5	165900	captured
197	cust_025	5	87200	captured
198	cust_025	5	89400	captured
199	cust_025	5	363100	captured
200	cust_025	5	300200	captured
201	cust_026	5	346700	captured
202	cust_026	5	392500	captured
203	cust_026	5	54300	captured
204	cust_026	5	90600	captured
205	cust_026	5	59600	captured
206	cust_026	5	339800	captured
207	cust_026	5	287900	captured
208	cust_026	5	99500	captured
209	cust_027	1	166900	captured
210	cust_027	1	165800	captured
211	cust_027	1	449300	captured
212	cust_027	1	377500	captured
213	cust_027	1	124800	captured
214	cust_027	1	355600	captured
215	cust_027	1	160300	captured
216	cust_027	1	238100	captured
217	cust_028	5	214600	captured
218	cust_028	5	71700	captured
219	cust_028	5	373000	captured
220	cust_028	5	460800	captured
221	cust_028	5	90200	captured
222	cust_028	5	51400	captured
223	cust_028	5	452800	captured
224	cust_028	5	22000	captured
225	cust_029	1	203600	captured
226	cust_029	1	146200	captured
227	cust_029	1	342900	captured
228	cust_029	1	407800	captured
229	cust_029	1	404300	captured
230	cust_029	1	185100	captured
231	cust_029	1	338500	captured
232	cust_029	1	58000	captured
233	cust_030	1	320400	captured
234	cust_030	1	11700	captured
235	cust_030	1	329800	captured
236	cust_030	1	227200	captured
237	cust_030	1	382700	captured
238	cust_030	1	243600	captured
239	cust_030	1	356500	captured
240	cust_030	1	465200	captured
241	cust_031	20	408600	captured
242	cust_031	20	136800	captured
243	cust_031	20	165500	captured
244	cust_031	20	253000	captured
245	cust_031	20	188300	captured
246	cust_031	20	57900	captured
247	cust_031	20	484400	captured
248	cust_031	20	454100	captured
249	cust_032	1	266900	captured
250	cust_032	1	56800	captured
251	cust_032	1	51000	captured
252	cust_032	1	488500	captured
253	cust_032	1	400500	captured
254	cust_032	1	421900	captured
255	cust_032	1	445000	captured
256	cust_032	1	138900	captured
257	cust_033	1	426000	captured
258	cust_033	1	75600	captured
259	cust_033	1	162200	captured
260	cust_033	1	66100	captured
261	cust_033	1	497400	captured
262	cust_033	1	65600	captured
263	cust_033	1	202600	captured
264	cust_033	1	340700	captured
265	cust_034	1	476600	captured
266	cust_034	1	211600	captured
267	cust_034	1	484200	captured
268	cust_034	1	497000	captured
269	cust_034	1	42500	captured
270	cust_034	1	77100	captured
271	cust_034	1	353400	captured
272	cust_034	1	488100	captured
273	cust_035	15	438200	captured
274	cust_035	15	269100	captured
275	cust_035	15	223600	captured
276	cust_035	15	177300	captured
277	cust_035	15	267300	captured
278	cust_035	15	205500	captured
279	cust_035	15	227500	captured
280	cust_035	15	334200	captured
281	cust_036	1	255700	captured
282	cust_036	1	384500	captured
283	cust_036	1	269000	captured
284	cust_036	1	69400	captured
285	cust_036	1	17600	captured
286	cust_036	1	385400	captured
287	cust_036	1	471200	captured
288	cust_036	1	91900	captured
289	cust_037	1	450400	captured
290	cust_037	1	184600	captured
291	cust_037	1	424400	captured
292	cust_037	1	227200	captured
293	cust_037	1	118500	captured
294	cust_037	1	295900	captured
295	cust_037	1	66300	captured
296	cust_037	1	210100	captured
297	cust_038	1	243400	captured
298	cust_038	1	139200	captured
299	cust_038	1	368900	captured
300	cust_038	1	455000	captured
301	cust_038	1	257800	captured
302	cust_038	1	443300	captured
303	cust_038	1	16400	captured
304	cust_038	1	464300	captured
305	cust_039	1	94800	captured
306	cust_039	1	120000	captured
307	cust_039	1	226600	captured
308	cust_039	1	104500	captured
309	cust_039	1	97600	captured
310	cust_039	1	463200	captured
311	cust_039	1	137300	captured
312	cust_039	1	233100	captured
313	cust_040	1	182500	captured
314	cust_040	1	290800	captured
315	cust_040	1	176700	captured
316	cust_040	1	226200	captured
317	cust_040	1	424000	captured
318	cust_040	1	410200	captured
319	cust_040	1	215700	captured
320	cust_040	1	51600	captured
321	cust_041	1	356900	captured
322	cust_041	1	236600	captured
323	cust_041	1	46100	captured
324	cust_041	1	12900	captured
325	cust_041	1	283200	captured
326	cust_041	1	117100	captured
327	cust_041	1	224500	captured
328	cust_041	1	142300	captured
329	cust_042	20	371900	captured
330	cust_042	20	461900	captured
331	cust_042	20	360300	captured
332	cust_042	20	469400	captured
333	cust_042	20	17900	captured
334	cust_042	20	101600	captured
335	cust_042	20	71600	captured
336	cust_042	20	132100	captured
337	cust_043	15	39500	captured
338	cust_043	15	312400	captured
339	cust_043	15	487100	captured
340	cust_043	15	462600	captured
341	cust_043	15	131300	captured
342	cust_043	15	362000	captured
343	cust_043	15	114400	captured
344	cust_043	15	44200	captured
345	cust_044	1	308700	captured
346	cust_044	1	42600	captured
347	cust_044	1	303100	captured
348	cust_044	1	182000	captured
349	cust_044	1	214400	captured
350	cust_044	1	94200	captured
351	cust_044	1	299700	captured
352	cust_044	1	468600	captured
353	cust_045	5	136600	captured
354	cust_045	5	203900	captured
355	cust_045	5	143100	captured
356	cust_045	5	155000	captured
357	cust_045	5	347700	captured
358	cust_045	5	30300	captured
359	cust_045	5	156900	captured
360	cust_045	5	282100	captured
361	cust_046	5	213200	captured
362	cust_046	5	228500	captured
363	cust_046	5	140400	captured
364	cust_046	5	98500	captured
365	cust_046	5	323300	captured
366	cust_046	5	41700	captured
367	cust_046	5	395500	captured
368	cust_046	5	192200	captured
369	cust_047	1	387000	captured
370	cust_047	1	296400	captured
371	cust_047	1	260000	captured
372	cust_047	1	196400	captured
373	cust_047	1	192600	captured
374	cust_047	1	29300	captured
375	cust_047	1	168200	captured
376	cust_047	1	336400	captured
377	cust_048	1	238200	captured
378	cust_048	1	66800	captured
379	cust_048	1	238600	captured
380	cust_048	1	297600	captured
381	cust_048	1	427300	captured
382	cust_048	1	337400	captured
383	cust_048	1	449200	captured
384	cust_048	1	281200	captured
385	cust_049	1	104400	captured
386	cust_049	1	223900	captured
387	cust_049	1	156200	captured
388	cust_049	1	485600	captured
389	cust_049	1	227400	captured
390	cust_049	1	41300	captured
391	cust_049	1	98800	captured
392	cust_049	1	498700	captured
393	cust_050	5	293100	captured
394	cust_050	5	266900	captured
395	cust_050	5	367400	captured
396	cust_050	5	428900	captured
397	cust_050	5	104700	captured
398	cust_050	5	325500	captured
399	cust_050	5	482300	captured
400	cust_050	5	165700	captured
401	cust_051	1	46300	captured
402	cust_051	1	367200	captured
403	cust_051	1	11300	captured
404	cust_051	1	435900	captured
405	cust_051	1	451000	captured
406	cust_051	1	171400	captured
407	cust_051	1	308300	captured
408	cust_051	1	363300	captured
409	cust_052	1	280400	captured
410	cust_052	1	267100	captured
411	cust_052	1	112000	captured
412	cust_052	1	256000	captured
413	cust_052	1	425400	captured
414	cust_052	1	263300	captured
415	cust_052	1	344500	captured
416	cust_052	1	277200	captured
417	cust_053	5	252200	captured
418	cust_053	5	464100	captured
419	cust_053	5	114200	captured
420	cust_053	5	167100	captured
421	cust_053	5	354400	captured
422	cust_053	5	320500	captured
423	cust_053	5	152500	captured
424	cust_053	5	476200	captured
425	cust_054	1	342600	captured
426	cust_054	1	458800	captured
427	cust_054	1	10300	captured
428	cust_054	1	258900	captured
429	cust_054	1	245000	captured
430	cust_054	1	182100	captured
431	cust_054	1	362100	captured
432	cust_054	1	485100	captured
433	cust_055	15	273900	captured
434	cust_055	15	390900	captured
435	cust_055	15	371900	captured
436	cust_055	15	372200	captured
437	cust_055	15	185000	captured
438	cust_055	15	428700	captured
439	cust_055	15	397600	captured
440	cust_055	15	149000	captured
441	cust_056	20	79400	captured
442	cust_056	20	242400	captured
443	cust_056	20	432200	captured
444	cust_056	20	284500	captured
445	cust_056	20	86500	captured
446	cust_056	20	202400	captured
447	cust_056	20	264200	captured
448	cust_056	20	194000	captured
449	cust_057	1	130700	captured
450	cust_057	1	30000	captured
451	cust_057	1	47800	captured
452	cust_057	1	210500	captured
453	cust_057	1	399200	captured
454	cust_057	1	69600	captured
455	cust_057	1	383000	captured
456	cust_057	1	349500	captured
457	cust_058	20	481500	captured
458	cust_058	20	169200	captured
459	cust_058	20	324500	captured
460	cust_058	20	414900	captured
461	cust_058	20	337300	captured
462	cust_058	20	209800	captured
463	cust_058	20	130800	captured
464	cust_058	20	14500	captured
465	cust_059	1	358200	captured
466	cust_059	1	189200	captured
467	cust_059	1	154000	captured
468	cust_059	1	434300	captured
469	cust_059	1	390500	captured
470	cust_059	1	51100	captured
471	cust_059	1	466600	captured
472	cust_059	1	214100	captured
473	cust_060	1	383900	captured
474	cust_060	1	119200	captured
475	cust_060	1	390600	captured
476	cust_060	1	445100	captured
477	cust_060	1	467800	captured
478	cust_060	1	497700	captured
479	cust_060	1	269900	captured
480	cust_060	1	372500	captured
481	cust_061	15	423500	captured
482	cust_061	15	359500	captured
483	cust_061	15	458800	captured
484	cust_061	15	375200	captured
485	cust_061	15	140300	captured
486	cust_061	15	398800	captured
487	cust_061	15	378600	captured
488	cust_061	15	222300	captured
489	cust_062	1	237100	captured
490	cust_062	1	437000	captured
491	cust_062	1	406900	captured
492	cust_062	1	205900	captured
493	cust_062	1	234900	captured
494	cust_062	1	370300	captured
495	cust_062	1	73400	captured
496	cust_062	1	244000	captured
497	cust_063	1	232500	captured
498	cust_063	1	285100	captured
499	cust_063	1	271900	captured
500	cust_063	1	452400	captured
501	cust_063	1	76000	captured
502	cust_063	1	123300	captured
503	cust_063	1	133500	captured
504	cust_063	1	199400	captured
505	cust_064	5	135100	captured
506	cust_064	5	185200	captured
507	cust_064	5	62600	captured
508	cust_064	5	349800	captured
509	cust_064	5	343900	captured
510	cust_064	5	281000	captured
511	cust_064	5	454500	captured
512	cust_064	5	391600	captured
513	cust_065	5	61000	captured
514	cust_065	5	179400	captured
515	cust_065	5	354100	captured
516	cust_065	5	329000	captured
517	cust_065	5	488400	captured
518	cust_065	5	26000	captured
519	cust_065	5	481600	captured
520	cust_065	5	321600	captured
521	cust_066	5	14800	captured
522	cust_066	5	298100	captured
523	cust_066	5	254600	captured
524	cust_066	5	329400	captured
525	cust_066	5	353200	captured
526	cust_066	5	450900	captured
527	cust_066	5	457300	captured
528	cust_066	5	190600	captured
529	cust_067	5	189700	captured
530	cust_067	5	233500	captured
531	cust_067	5	367000	captured
532	cust_067	5	407800	captured
533	cust_067	5	33700	captured
534	cust_067	5	328500	captured
535	cust_067	5	285300	captured
536	cust_067	5	341200	captured
537	cust_068	20	145200	captured
538	cust_068	20	392800	captured
539	cust_068	20	114500	captured
540	cust_068	20	447500	captured
541	cust_068	20	32000	captured
542	cust_068	20	332700	captured
543	cust_068	20	494800	captured
544	cust_068	20	472300	captured
545	cust_069	20	32200	captured
546	cust_069	20	78700	captured
547	cust_069	20	361100	captured
548	cust_069	20	121100	captured
549	cust_069	20	388200	captured
550	cust_069	20	158800	captured
551	cust_069	20	51100	captured
552	cust_069	20	223100	captured
553	cust_070	5	278100	captured
554	cust_070	5	183300	captured
555	cust_070	5	382400	captured
556	cust_070	5	277700	captured
557	cust_070	5	286400	captured
558	cust_070	5	320500	captured
559	cust_070	5	237900	captured
560	cust_070	5	355300	captured
561	cust_071	1	77000	captured
562	cust_071	1	395200	captured
563	cust_071	1	25800	captured
564	cust_071	1	451800	captured
565	cust_071	1	52600	captured
566	cust_071	1	296600	captured
567	cust_071	1	193600	captured
568	cust_071	1	66200	captured
569	cust_072	20	42900	captured
570	cust_072	20	35400	captured
571	cust_072	20	212500	captured
572	cust_072	20	173300	captured
573	cust_072	20	26600	captured
574	cust_072	20	134800	captured
575	cust_072	20	205400	captured
576	cust_072	20	113400	captured
577	cust_073	5	103700	captured
578	cust_073	5	472000	captured
579	cust_073	5	188500	captured
580	cust_073	5	390900	captured
581	cust_073	5	219900	captured
582	cust_073	5	312100	captured
583	cust_073	5	147400	captured
584	cust_073	5	103800	captured
585	cust_074	1	264800	captured
586	cust_074	1	98500	captured
587	cust_074	1	484000	captured
588	cust_074	1	31000	captured
589	cust_074	1	265500	captured
590	cust_074	1	481600	captured
591	cust_074	1	317400	captured
592	cust_074	1	334900	captured
593	cust_075	20	172400	captured
594	cust_075	20	72200	captured
595	cust_075	20	495000	captured
596	cust_075	20	208900	captured
597	cust_075	20	93400	captured
598	cust_075	20	257000	captured
599	cust_075	20	109100	captured
600	cust_075	20	473600	captured
601	cust_076	1	294400	captured
602	cust_076	1	446400	captured
603	cust_076	1	360900	captured
604	cust_076	1	313500	captured
605	cust_076	1	66400	captured
606	cust_076	1	424400	captured
607	cust_076	1	289500	captured
608	cust_076	1	20300	captured
609	cust_077	5	411500	captured
610	cust_077	5	96400	captured
611	cust_077	5	365100	captured
612	cust_077	5	306700	captured
613	cust_077	5	386600	captured
614	cust_077	5	135300	captured
615	cust_077	5	366700	captured
616	cust_077	5	154200	captured
617	cust_078	20	437400	captured
618	cust_078	20	231200	captured
619	cust_078	20	450800	captured
620	cust_078	20	406000	captured
621	cust_078	20	390800	captured
622	cust_078	20	366800	captured
623	cust_078	20	495300	captured
624	cust_078	20	229800	captured
625	cust_079	1	211100	captured
626	cust_079	1	80900	captured
627	cust_079	1	238400	captured
628	cust_079	1	379200	captured
629	cust_079	1	209700	captured
630	cust_079	1	390600	captured
631	cust_079	1	476800	captured
632	cust_079	1	320400	captured
633	cust_080	1	33500	captured
634	cust_080	1	414900	captured
635	cust_080	1	276200	captured
636	cust_080	1	158900	captured
637	cust_080	1	409400	captured
638	cust_080	1	183700	captured
639	cust_080	1	300600	captured
640	cust_080	1	221600	captured
\.


--
-- Data for Name: diagnoses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.diagnoses (id, failure_id, archetype, owner, confidence, reasoning, model_used, created_at) FROM stdin;
1	1	lifecycle	customer_temp	0.92	card expired indicates lifecycle issue for temporary customer	groq	2026-08-25 22:02:13.559887+00
2	2	intent	merchant	0.88	checkout misconfiguration is a merchant‑side intent blocker	groq	2026-08-25 22:02:13.559887+00
3	3	technical	infra	0.94	bank/PSP timeout is a technical infrastructure failure	groq	2026-08-25 22:02:13.559887+00
4	4	intent	customer_temp	0.86	QR scan timeout caused customer to leave, intent drop	groq	2026-08-25 22:02:13.559887+00
5	5	lifecycle	customer_temp	0.92	card expired indicates lifecycle issue for temporary customer	groq	2026-08-25 22:02:13.559887+00
6	6	intent	merchant	0.89	session dropped at fee reveal (fee shock) is a merchant‑side intent issue	groq	2026-08-25 22:02:13.559887+00
7	7	intent	customer_temp	0.9	dropped at OTP step reflects intent failure for temporary customer	groq	2026-08-25 22:02:13.559887+00
8	8	intent	merchant	0.89	session dropped at fee reveal (fee shock) is a merchant‑side intent issue	groq	2026-08-25 22:02:13.559887+00
9	9	intent	merchant	0.89	session dropped at fee reveal (fee shock) is a merchant‑side intent issue	groq	2026-08-25 22:02:13.559887+00
10	10	intent	merchant	0.88	checkout misconfiguration is a merchant‑side intent blocker	groq	2026-08-25 22:02:13.559887+00
11	11	affordability	customer_temp	0.9	single insufficient balance	groq	2026-08-25 22:02:13.559887+00
12	12	affordability	customer_temp	0.9	single insufficient balance	groq	2026-08-25 22:02:13.559887+00
13	13	technical	merchant	0.9	checkout config error	groq	2026-08-25 22:02:13.559887+00
14	14	technical	infra	0.9	gateway 5xx timeout	groq	2026-08-25 22:02:13.559887+00
15	15	lifecycle	merchant	0.9	pre‑debit notification <24h	groq	2026-08-25 22:02:13.559887+00
16	16	intent	customer_temp	0.9	offline QR timeout, no signal	groq	2026-08-25 22:02:13.559887+00
17	17	intent	customer_temp	0.9	offline QR timeout, no signal	groq	2026-08-25 22:02:13.559887+00
18	18	technical	infra	0.9	gateway 5xx timeout	groq	2026-08-25 22:02:13.559887+00
19	19	intent	customer_temp	0.9	offline QR timeout, no signal	groq	2026-08-25 22:02:13.559887+00
20	20	lifecycle	merchant	0.9	pre‑debit notification <24h	groq	2026-08-25 22:02:13.559887+00
21	21	affordability	customer_temp	0.95	Single insufficient balance decline indicates temporary affordability issue	groq	2026-08-25 22:02:13.559887+00
22	22	affordability	customer_structural	0.95	Repeated insufficient balance across cycles indicates structural affordability problem	groq	2026-08-25 22:02:13.559887+00
23	23	technical	infra	0.96	UPI request timed out at PSP due to bank server degradation	groq	2026-08-25 22:02:13.559887+00
24	24	technical	infra	0.96	UPI request timed out at PSP due to bank server degradation	groq	2026-08-25 22:02:13.559887+00
25	25	technical	infra	0.93	Offline QR scan timed out, indicating infrastructure timeout	groq	2026-08-25 22:02:13.559887+00
26	26	lifecycle	merchant	0.94	Pre‑debit notification sent less than 24 h before debit, a lifecycle issue caused by merchant timing	groq	2026-08-25 22:02:13.559887+00
27	27	technical	infra	0.96	UPI request timed out at PSP due to bank server degradation	groq	2026-08-25 22:02:13.559887+00
28	28	technical	infra	0.96	Issuer gateway returned 502 error during authorization, a technical infrastructure failure	groq	2026-08-25 22:02:13.559887+00
29	29	technical	infra	0.96	UPI request timed out at PSP due to bank server degradation	groq	2026-08-25 22:02:13.559887+00
30	30	intent	merchant	0.9	Customer abandoned payment at fee reveal, a fee‑shock scenario linked to merchant configuration	groq	2026-08-25 22:02:13.559887+00
31	31	intent	customer_temp	0.9	QR scan timed out, customer left	groq	2026-08-25 22:02:13.559887+00
32	32	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
33	33	affordability	customer_temp	0.9	bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
34	34	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
35	35	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
36	36	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
37	37	intent	customer_temp	0.9	QR scan timed out, customer left	groq	2026-08-25 22:02:13.559887+00
38	38	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
39	39	affordability	customer_temp	0.9	bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
40	40	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
41	41	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
42	42	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-25 22:02:13.559887+00
43	43	technical	infra	0.9	issuer gateway returned 502	groq	2026-08-25 22:02:13.559887+00
44	44	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
45	45	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
46	46	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
47	47	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-25 22:02:13.559887+00
48	48	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
49	49	affordability	customer_temp	0.9	bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
50	50	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-25 22:02:13.559887+00
51	51	affordability	customer_temp	0.9	single insufficient balance	groq	2026-08-25 22:02:13.559887+00
52	52	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
53	53	affordability	customer_structural	0.9	repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
54	54	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
55	55	affordability	customer_temp	0.9	single insufficient balance	groq	2026-08-25 22:02:13.559887+00
56	56	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
57	57	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
58	58	technical	infra	0.9	gateway returned 5xx error	groq	2026-08-25 22:02:13.559887+00
59	59	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-25 22:02:13.559887+00
60	60	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
61	61	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
62	62	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
63	63	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
64	64	lifecycle	merchant	0.9	Pre‑debit notification sent less than 24 h before debit	groq	2026-08-25 22:02:13.559887+00
65	65	intent	merchant	0.9	User abandoned after seeing fees (fee shock)	groq	2026-08-25 22:02:13.559887+00
66	66	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
67	67	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
68	68	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
69	69	affordability	customer_structural	0.9	Repeated insufficient balance declines indicating structural affordability issue	groq	2026-08-25 22:02:13.559887+00
70	70	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
71	71	affordability	customer_structural	0.9	repeated insufficient balance indicates structural affordability issue	groq	2026-08-25 22:02:13.559887+00
72	72	affordability	customer_structural	0.9	repeated insufficient balance indicates structural affordability issue	groq	2026-08-25 22:02:13.559887+00
73	73	lifecycle	customer_temp	0.9	card expiration prevents payment	groq	2026-08-25 22:02:13.559887+00
74	74	intent	customer_temp	0.9	user dropped at OTP step, indicating intent issue	groq	2026-08-25 22:02:13.559887+00
75	75	intent	merchant	0.9	fee shock caused abandonment, merchant‑side fee configuration	groq	2026-08-25 22:02:13.559887+00
76	76	technical	merchant	0.9	checkout misconfiguration rejected payload, merchant config error	groq	2026-08-25 22:02:13.559887+00
77	77	intent	customer_temp	0.9	user dropped at OTP step, indicating intent issue	groq	2026-08-25 22:02:13.559887+00
78	78	technical	merchant	0.9	checkout misconfiguration rejected payload, merchant config error	groq	2026-08-25 22:02:13.559887+00
79	79	intent	merchant	0.9	fee shock caused abandonment, merchant‑side fee configuration	groq	2026-08-25 22:02:13.559887+00
80	80	technical	infra	0.9	UPI request timed out at PSP, bank/gateway timeout	groq	2026-08-25 22:02:13.559887+00
81	81	technical	infra	0.95	bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
82	82	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-25 22:02:13.559887+00
83	83	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
84	84	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
85	85	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-25 22:02:13.559887+00
86	86	technical	infra	0.95	QR scan timeout in offline store	groq	2026-08-25 22:02:13.559887+00
87	87	technical	infra	0.95	QR scan timeout in offline store	groq	2026-08-25 22:02:13.559887+00
88	88	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-25 22:02:13.559887+00
89	89	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-25 22:02:13.559887+00
90	90	intent	merchant	0.9	merchant checkout misconfiguration rejected payload	groq	2026-08-25 22:02:13.559887+00
91	91	technical	infra	0.9	bank/PSP timeout	groq	2026-08-25 22:02:13.559887+00
92	92	technical	infra	0.9	gateway 5xx error	groq	2026-08-25 22:02:13.559887+00
93	93	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-25 22:02:13.559887+00
94	94	technical	infra	0.9	bank/PSP timeout	groq	2026-08-25 22:02:13.559887+00
95	95	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-25 22:02:13.559887+00
96	96	intent	customer_temp	0.9	customer abandoned after QR timeout	groq	2026-08-25 22:02:13.559887+00
97	97	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
98	98	lifecycle	merchant	0.9	pre-debit notification sent <24h	groq	2026-08-25 22:02:13.559887+00
99	99	intent	merchant	0.9	fee shock caused abandonment	groq	2026-08-25 22:02:13.559887+00
100	100	intent	customer_temp	0.9	customer dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
101	101	lifecycle	customer_temp	0.9	card expired on file	groq	2026-08-25 22:02:13.559887+00
102	102	intent	merchant	0.9	checkout payload rejected due to merchant misconfiguration	groq	2026-08-25 22:02:13.559887+00
103	103	technical	infra	0.9	UPI request timed out at PSP/bank server	groq	2026-08-25 22:02:13.559887+00
104	104	intent	customer_temp	0.9	QR scan timed out; customer left before completing payment	groq	2026-08-25 22:02:13.559887+00
105	105	lifecycle	customer_temp	0.9	card expired on file	groq	2026-08-25 22:02:13.559887+00
106	106	intent	merchant	0.9	customer dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
107	107	intent	customer_temp	0.9	customer dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
108	108	intent	merchant	0.9	customer dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
109	109	intent	merchant	0.9	customer dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
110	110	intent	merchant	0.9	checkout payload rejected due to merchant misconfiguration	groq	2026-08-25 22:02:13.559887+00
111	111	affordability	customer_temp	0.9	bank declined: insufficient balance	groq	2026-08-25 22:02:13.559887+00
112	112	affordability	customer_temp	0.9	bank declined: insufficient balance	groq	2026-08-25 22:02:13.559887+00
113	113	intent	merchant	0.9	merchant checkout misconfiguration rejected payment payload	groq	2026-08-25 22:02:13.559887+00
114	114	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
115	115	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
116	116	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
117	117	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
118	118	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
119	119	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
120	120	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
121	121	affordability	customer_temp	0.9	Insufficient balance for a single attempt	groq	2026-08-25 22:02:13.559887+00
122	122	affordability	customer_structural	0.9	Repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
123	123	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
124	124	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
125	125	intent	customer_temp	0.9	QR scan timed out, customer left before completing payment	groq	2026-08-25 22:02:13.559887+00
126	126	lifecycle	merchant	0.9	Pre-debit notification sent less than 24h before charge	groq	2026-08-25 22:02:13.559887+00
127	127	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
128	128	technical	infra	0.9	Issuer gateway returned 502 error during authorization	groq	2026-08-25 22:02:13.559887+00
129	129	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
130	130	intent	merchant	0.9	Customer abandoned at fee reveal, indicating fee shock	groq	2026-08-25 22:02:13.559887+00
131	131	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
132	132	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
133	133	affordability	customer_temp	0.9	Bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
134	134	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
135	135	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
136	136	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
137	137	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
138	138	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
139	139	affordability	customer_temp	0.9	Bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
140	140	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-25 22:02:13.559887+00
141	141	intent	customer_temp	0.9	dropped at OTP, no further signal	groq	2026-08-25 22:02:13.559887+00
142	142	technical	infra	0.9	UPI request timed out at PSP/bank	groq	2026-08-25 22:02:13.559887+00
143	143	technical	infra	0.9	issuer gateway returned 502 error	groq	2026-08-25 22:02:13.559887+00
144	144	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
145	145	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
146	146	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
147	147	technical	infra	0.9	UPI request timed out at PSP/bank	groq	2026-08-25 22:02:13.559887+00
148	148	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
149	149	affordability	customer_temp	0.9	bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
150	150	technical	infra	0.9	UPI request timed out at PSP/bank	groq	2026-08-25 22:02:13.559887+00
151	151	affordability	customer_temp	0.96	Bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
152	152	lifecycle	merchant	0.96	Pre‑debit notification sent <24h before debit, violating mandate rules	groq	2026-08-25 22:02:13.559887+00
153	153	affordability	customer_structural	0.96	Repeated insufficient balance across consecutive cycles	groq	2026-08-25 22:02:13.559887+00
154	154	intent	customer_temp	0.96	User dropped at OTP step, indicating intent issue	groq	2026-08-25 22:02:13.559887+00
155	155	affordability	customer_temp	0.96	Bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
156	156	lifecycle	merchant	0.96	Pre‑debit notification sent <24h before debit, violating mandate rules	groq	2026-08-25 22:02:13.559887+00
157	157	lifecycle	merchant	0.96	Pre‑debit notification sent <24h before debit, violating mandate rules	groq	2026-08-25 22:02:13.559887+00
158	158	technical	infra	0.96	Issuer gateway returned 502 error during authorization	groq	2026-08-25 22:02:13.559887+00
159	159	technical	infra	0.96	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
160	160	intent	customer_temp	0.96	User dropped at OTP step, indicating intent issue	groq	2026-08-25 22:02:13.559887+00
161	161	technical	infra	0.95	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
162	162	technical	infra	0.95	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
163	163	technical	infra	0.95	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
164	164	lifecycle	merchant	0.95	Pre‑debit notification sent less than 24 h before debit (mandate breach)	groq	2026-08-25 22:02:13.559887+00
165	165	intent	merchant	0.95	User abandoned at fee reveal; merchant fee shock	groq	2026-08-25 22:02:13.559887+00
166	166	affordability	customer_temp	0.95	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
167	167	intent	customer_temp	0.95	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
168	168	intent	customer_temp	0.95	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
169	169	affordability	customer_temp	0.95	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
170	170	intent	customer_temp	0.95	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
171	171	affordability	customer_structural	0.96	repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
172	172	affordability	customer_structural	0.96	repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
173	173	lifecycle	customer_temp	0.95	card expired	groq	2026-08-25 22:02:13.559887+00
174	174	intent	customer_temp	0.94	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
175	175	intent	merchant	0.93	fee shock caused abandonment	groq	2026-08-25 22:02:13.559887+00
176	176	technical	merchant	0.95	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
177	177	intent	customer_temp	0.94	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
178	178	technical	merchant	0.95	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
179	179	intent	merchant	0.93	fee shock caused abandonment	groq	2026-08-25 22:02:13.559887+00
180	180	technical	infra	0.97	UPI bank timeout	groq	2026-08-25 22:02:13.559887+00
181	181	technical	infra	0.95	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
182	182	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
183	183	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-25 22:02:13.559887+00
184	184	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-25 22:02:13.559887+00
185	185	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
186	186	intent	customer_temp	0.9	QR scan timed out; customer left before completion, no further signal	groq	2026-08-25 22:02:13.559887+00
187	187	intent	customer_temp	0.9	QR scan timed out; customer left before completion, no further signal	groq	2026-08-25 22:02:13.559887+00
188	188	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
189	189	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
190	190	intent	merchant	0.9	Merchant checkout misconfiguration rejected payment payload	groq	2026-08-25 22:02:13.559887+00
191	191	technical	infra	0.95	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
192	192	technical	infra	0.95	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
193	193	affordability	customer_structural	0.9	Repeated insufficient balance across consecutive cycles	groq	2026-08-25 22:02:13.559887+00
194	194	technical	infra	0.95	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
195	195	affordability	customer_structural	0.9	Repeated insufficient balance across consecutive cycles	groq	2026-08-25 22:02:13.559887+00
196	196	intent	customer_temp	0.9	QR scan timed out and customer left before completion	groq	2026-08-25 22:02:13.559887+00
197	197	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-25 22:02:13.559887+00
198	198	lifecycle	merchant	0.9	Pre‑debit notification sent less than 24h before debit	groq	2026-08-25 22:02:13.559887+00
199	199	intent	merchant	0.9	User abandoned session at fee reveal (fee shock) before payment attempt	groq	2026-08-25 22:02:13.559887+00
200	200	intent	customer_temp	0.9	User dropped at OTP verification step	groq	2026-08-25 22:02:13.559887+00
201	201	lifecycle	customer_temp	0.95	card expired on file	groq	2026-08-25 22:02:13.559887+00
202	202	intent	merchant	0.9	merchant checkout misconfiguration rejected payload	groq	2026-08-25 22:02:13.559887+00
203	203	technical	infra	0.96	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
204	204	intent	customer_temp	0.9	QR scan timed out in‑store, customer left before completion	groq	2026-08-25 22:02:13.559887+00
205	205	lifecycle	customer_temp	0.95	card expired on file	groq	2026-08-25 22:02:13.559887+00
206	206	intent	merchant	0.9	session dropped at fee reveal (fee shock) before payment attempt	groq	2026-08-25 22:02:13.559887+00
207	207	intent	customer_temp	0.96	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
208	208	intent	merchant	0.9	session dropped at fee reveal (fee shock) before payment attempt	groq	2026-08-25 22:02:13.559887+00
209	209	intent	merchant	0.9	session dropped at fee reveal (fee shock) before payment attempt	groq	2026-08-25 22:02:13.559887+00
210	210	intent	merchant	0.9	merchant checkout misconfiguration rejected payload	groq	2026-08-25 22:02:13.559887+00
211	211	affordability	customer_temp	0.9	insufficient balance on first attempt	groq	2026-08-25 22:02:13.559887+00
212	212	affordability	customer_temp	0.9	insufficient balance on first attempt	groq	2026-08-25 22:02:13.559887+00
213	213	technical	merchant	0.9	checkout configuration error caused payload rejection	groq	2026-08-25 22:02:13.559887+00
214	214	technical	infra	0.9	gateway returned 502 (5xx) during authorization	groq	2026-08-25 22:02:13.559887+00
215	215	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit (mandate breach)	groq	2026-08-25 22:02:13.559887+00
216	216	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
217	217	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
218	218	technical	infra	0.9	gateway returned 502 (5xx) during authorization	groq	2026-08-25 22:02:13.559887+00
219	219	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
220	220	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit (mandate breach)	groq	2026-08-25 22:02:13.559887+00
221	221	affordability	customer_temp	0.95	insufficient balance on single attempt	groq	2026-08-25 22:02:13.559887+00
222	222	affordability	customer_structural	0.95	repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
223	223	technical	infra	0.94	UPI request timed out at PSP/bank server	groq	2026-08-25 22:02:13.559887+00
224	224	technical	infra	0.94	UPI request timed out at PSP/bank server	groq	2026-08-25 22:02:13.559887+00
225	225	intent	customer_temp	0.92	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
226	226	lifecycle	merchant	0.93	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
227	227	technical	infra	0.94	UPI request timed out at PSP/bank server	groq	2026-08-25 22:02:13.559887+00
228	228	technical	infra	0.94	issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
229	229	technical	infra	0.94	UPI request timed out at PSP/bank server	groq	2026-08-25 22:02:13.559887+00
230	230	intent	merchant	0.92	order dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
231	231	intent	customer_temp	0.9	QR scan timed out, customer left	groq	2026-08-25 22:02:13.559887+00
232	232	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
233	233	affordability	customer_temp	0.9	bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
234	234	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
235	235	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
236	236	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
237	237	intent	customer_temp	0.9	QR scan timed out, customer left	groq	2026-08-25 22:02:13.559887+00
238	238	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
239	239	affordability	customer_temp	0.9	bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
240	240	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
241	241	intent	customer_temp	0.95	User dropped at OTP step, no further signal	groq	2026-08-25 22:02:13.559887+00
242	242	technical	infra	0.96	UPI request timed out at PSP/bank, indicating a bank/PSP error	groq	2026-08-25 22:02:13.559887+00
243	243	technical	infra	0.96	Issuer gateway returned 502, a gateway/server error	groq	2026-08-25 22:02:13.559887+00
244	244	intent	merchant	0.94	Session dropped at fee reveal, indicating fee shock/merchant configuration issue	groq	2026-08-25 22:02:13.559887+00
245	245	intent	merchant	0.94	Session dropped at fee reveal, indicating fee shock/merchant configuration issue	groq	2026-08-25 22:02:13.559887+00
246	246	lifecycle	merchant	0.93	Pre‑debit notification sent <24 h before debit, a lifecycle compliance breach owned by merchant	groq	2026-08-25 22:02:13.559887+00
247	247	technical	infra	0.96	UPI request timed out at PSP/bank, indicating a bank/PSP error	groq	2026-08-25 22:02:13.559887+00
248	248	lifecycle	customer_temp	0.95	Card on file is expired, a lifecycle issue affecting the customer temporarily	groq	2026-08-25 22:02:13.559887+00
249	249	affordability	customer_temp	0.95	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
250	250	technical	infra	0.96	UPI request timed out at PSP/bank, indicating a bank/PSP error	groq	2026-08-25 22:02:13.559887+00
251	251	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-25 22:02:13.559887+00
252	252	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
253	253	affordability	customer_structural	0.9	repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
254	254	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
255	255	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-25 22:02:13.559887+00
256	256	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
257	257	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
258	258	technical	infra	0.9	gateway 5xx error during authorization	groq	2026-08-25 22:02:13.559887+00
259	259	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-25 22:02:13.559887+00
260	260	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
261	261	technical	infra	0.9	bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
262	262	technical	infra	0.9	bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
263	263	technical	infra	0.9	bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
264	264	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
265	265	intent	merchant	0.9	user dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
266	266	affordability	customer_temp	0.9	insufficient balance reported by bank	groq	2026-08-25 22:02:13.559887+00
267	267	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
268	268	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
269	269	affordability	customer_structural	0.9	repeated insufficient balance reported by bank	groq	2026-08-25 22:02:13.559887+00
270	270	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
271	271	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-25 22:02:13.559887+00
272	272	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-25 22:02:13.559887+00
273	273	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
274	274	intent	customer_temp	0.9	dropped at OTP	groq	2026-08-25 22:02:13.559887+00
275	275	intent	merchant	0.9	dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
276	276	technical	merchant	0.9	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
277	277	intent	customer_temp	0.9	dropped at OTP	groq	2026-08-25 22:02:13.559887+00
278	278	technical	merchant	0.9	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
279	279	intent	merchant	0.9	dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
280	280	technical	infra	0.9	bank/PSP timeout	groq	2026-08-25 22:02:13.559887+00
281	281	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
282	282	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
283	283	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-25 22:02:13.559887+00
284	284	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-25 22:02:13.559887+00
285	285	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
286	286	intent	customer_temp	0.9	QR scan timed out in-store; customer left before completion	groq	2026-08-25 22:02:13.559887+00
287	287	intent	customer_temp	0.9	QR scan timed out in-store; customer left before completion	groq	2026-08-25 22:02:13.559887+00
288	288	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
289	289	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
290	290	intent	merchant	0.9	Merchant checkout misconfiguration rejected payment payload	groq	2026-08-25 22:02:13.559887+00
291	291	technical	infra	0.95	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
292	292	technical	infra	0.95	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
293	293	affordability	customer_structural	0.9	Repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
294	294	technical	infra	0.95	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
295	295	affordability	customer_structural	0.9	Repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
296	296	intent	customer_temp	0.85	QR scan timed out; customer left before completion	groq	2026-08-25 22:02:13.559887+00
297	297	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-25 22:02:13.559887+00
298	298	lifecycle	merchant	0.9	Pre-debit notification sent less than 24h before debit	groq	2026-08-25 22:02:13.559887+00
299	299	intent	merchant	0.85	User abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
300	300	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
301	301	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
302	302	intent	merchant	0.9	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
303	303	technical	infra	0.9	bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
304	304	intent	customer_temp	0.9	QR scan timeout, customer left	groq	2026-08-25 22:02:13.559887+00
305	305	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
306	306	intent	merchant	0.9	abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
307	307	intent	customer_temp	0.9	abandoned at OTP	groq	2026-08-25 22:02:13.559887+00
308	308	intent	merchant	0.9	abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
309	309	intent	merchant	0.9	abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
310	310	intent	merchant	0.9	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
311	311	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-25 22:02:13.559887+00
312	312	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-25 22:02:13.559887+00
313	313	intent	merchant	0.9	checkout configuration error from merchant side	groq	2026-08-25 22:02:13.559887+00
314	314	technical	infra	0.9	gateway returned 502 error	groq	2026-08-25 22:02:13.559887+00
315	315	lifecycle	merchant	0.9	pre‑debit notification sent less than 24h before debit	groq	2026-08-25 22:02:13.559887+00
316	316	intent	customer_temp	0.9	QR scan timed out, customer left without further signal	groq	2026-08-25 22:02:13.559887+00
317	317	intent	customer_temp	0.9	QR scan timed out, customer left without further signal	groq	2026-08-25 22:02:13.559887+00
318	318	technical	infra	0.9	gateway returned 502 error	groq	2026-08-25 22:02:13.559887+00
319	319	intent	customer_temp	0.9	QR scan timed out, customer left without further signal	groq	2026-08-25 22:02:13.559887+00
320	320	lifecycle	merchant	0.9	pre‑debit notification sent less than 24h before debit	groq	2026-08-25 22:02:13.559887+00
321	321	affordability	customer_temp	0.9	insufficient balance on single attempt	groq	2026-08-25 22:02:13.559887+00
322	322	affordability	customer_structural	0.9	repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
323	323	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
324	324	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
325	325	technical	infra	0.9	QR scan timed out in-store, customer left before completion	groq	2026-08-25 22:02:13.559887+00
326	326	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit (mandate breach)	groq	2026-08-25 22:02:13.559887+00
327	327	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
328	328	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
329	329	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
330	330	intent	merchant	0.9	session dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
331	331	intent	customer_temp	0.9	customer left before completing QR scan, indicating intent drop	groq	2026-08-25 22:02:13.559887+00
332	332	lifecycle	merchant	0.9	pre‑debit notification sent less than 24h before debit	groq	2026-08-25 22:02:13.559887+00
333	333	affordability	customer_temp	0.9	bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
334	334	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
335	335	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
336	336	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
337	337	intent	customer_temp	0.9	customer left before completing QR scan, indicating intent drop	groq	2026-08-25 22:02:13.559887+00
338	338	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
339	339	affordability	customer_temp	0.9	bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
340	340	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
341	341	intent	customer_temp	0.9	dropped at OTP	groq	2026-08-25 22:02:13.559887+00
342	342	technical	infra	0.9	UPI bank timeout	groq	2026-08-25 22:02:13.559887+00
343	343	technical	infra	0.9	gateway 5xx error	groq	2026-08-25 22:02:13.559887+00
344	344	intent	merchant	0.9	abandoned at fee reveal	groq	2026-08-25 22:02:13.559887+00
345	345	intent	merchant	0.9	abandoned at fee reveal	groq	2026-08-25 22:02:13.559887+00
346	346	lifecycle	merchant	0.9	pre-debit notification sent <24h	groq	2026-08-25 22:02:13.559887+00
347	347	technical	infra	0.9	UPI bank timeout	groq	2026-08-25 22:02:13.559887+00
348	348	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
349	349	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-25 22:02:13.559887+00
350	350	technical	infra	0.9	UPI bank timeout	groq	2026-08-25 22:02:13.559887+00
351	351	affordability	customer_temp	0.95	insufficient balance for this transaction	groq	2026-08-25 22:02:13.559887+00
352	352	lifecycle	merchant	0.95	pre‑debit notification sent less than 24h before debit	groq	2026-08-25 22:02:13.559887+00
353	353	affordability	customer_structural	0.95	repeated insufficient balance across cycles	groq	2026-08-25 22:02:13.559887+00
354	354	intent	customer_temp	0.95	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
355	355	affordability	customer_temp	0.95	insufficient balance for this transaction	groq	2026-08-25 22:02:13.559887+00
356	356	lifecycle	merchant	0.95	pre‑debit notification sent less than 24h before debit	groq	2026-08-25 22:02:13.559887+00
357	357	lifecycle	merchant	0.95	pre‑debit notification sent less than 24h before debit	groq	2026-08-25 22:02:13.559887+00
358	358	technical	infra	0.95	gateway returned 502 error	groq	2026-08-25 22:02:13.559887+00
359	359	technical	infra	0.95	UPI request timed out at PSP	groq	2026-08-25 22:02:13.559887+00
360	360	intent	customer_temp	0.95	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
361	361	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
362	362	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
363	363	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
364	364	lifecycle	merchant	0.9	Pre‑debit notification sent less than 24 h before debit (mandate breach)	groq	2026-08-25 22:02:13.559887+00
365	365	intent	merchant	0.9	User abandoned session at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
366	366	affordability	customer_temp	0.9	Bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
367	367	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
368	368	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
369	369	affordability	customer_temp	0.9	Bank declined due to insufficient balance	groq	2026-08-25 22:02:13.559887+00
370	370	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
371	371	affordability	customer_structural	0.9	repeated insufficient balance (4th cycle)	groq	2026-08-25 22:02:13.559887+00
372	372	affordability	customer_structural	0.9	repeated insufficient balance (4th cycle)	groq	2026-08-25 22:02:13.559887+00
373	373	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
374	374	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
375	375	intent	merchant	0.9	abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
376	376	technical	merchant	0.9	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
377	377	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
378	378	technical	merchant	0.9	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
379	379	intent	merchant	0.9	abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
380	380	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-25 22:02:13.559887+00
381	381	technical	infra	0.9	bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
382	382	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-25 22:02:13.559887+00
383	383	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
384	384	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
385	385	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-25 22:02:13.559887+00
386	386	intent	customer_temp	0.9	offline QR timeout, customer left	groq	2026-08-25 22:02:13.559887+00
387	387	intent	customer_temp	0.9	offline QR timeout, customer left	groq	2026-08-25 22:02:13.559887+00
388	388	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-25 22:02:13.559887+00
389	389	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-25 22:02:13.559887+00
390	390	intent	merchant	0.9	checkout configuration error	groq	2026-08-25 22:02:13.559887+00
391	391	technical	infra	0.9	bank timeout error	groq	2026-08-25 22:02:13.559887+00
392	392	technical	infra	0.9	gateway returned 5xx error	groq	2026-08-25 22:02:13.559887+00
393	393	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-25 22:02:13.559887+00
394	394	technical	infra	0.9	bank timeout error	groq	2026-08-25 22:02:13.559887+00
395	395	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-25 22:02:13.559887+00
396	396	intent	customer_temp	0.9	offline QR scan timed out, customer left	groq	2026-08-25 22:02:13.559887+00
397	397	lifecycle	customer_temp	0.9	card expired	groq	2026-08-25 22:02:13.559887+00
398	398	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
399	399	intent	merchant	0.9	user dropped at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
400	400	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
401	401	lifecycle	customer_temp	0.9	card expired on file	groq	2026-08-25 22:02:13.559887+00
402	402	intent	merchant	0.9	merchant checkout misconfiguration	groq	2026-08-25 22:02:13.559887+00
403	403	technical	infra	0.9	UPI request timed out at PSP/bank server degraded	groq	2026-08-25 22:02:13.559887+00
404	404	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-25 22:02:13.559887+00
405	405	lifecycle	customer_temp	0.9	card expired on file	groq	2026-08-25 22:02:13.559887+00
406	406	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
407	407	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
408	408	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
409	409	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
410	410	intent	merchant	0.9	merchant checkout misconfiguration	groq	2026-08-25 22:02:13.559887+00
411	411	affordability	customer_temp	0.95	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
412	412	affordability	customer_structural	0.95	Repeated insufficient‑balance declines indicate a structural affordability issue	groq	2026-08-25 22:02:13.559887+00
413	413	technical	merchant	0.93	Checkout payload rejected because of merchant configuration error	groq	2026-08-25 22:02:13.559887+00
414	414	technical	infra	0.97	Issuer gateway returned 502 – bank/gateway timeout error	groq	2026-08-25 22:02:13.559887+00
415	415	lifecycle	merchant	0.94	Pre‑debit notification sent <24 h before debit violates mandate policy	groq	2026-08-25 22:02:13.559887+00
416	416	intent	customer_temp	0.96	QR scan timed out and customer left before completing payment	groq	2026-08-25 22:02:13.559887+00
417	417	intent	customer_temp	0.96	QR scan timed out and customer left before completing payment	groq	2026-08-25 22:02:13.559887+00
418	418	technical	infra	0.97	Issuer gateway returned 502 – bank/gateway timeout error	groq	2026-08-25 22:02:13.559887+00
419	419	intent	customer_temp	0.96	QR scan timed out and customer left before completing payment	groq	2026-08-25 22:02:13.559887+00
420	420	lifecycle	merchant	0.94	Pre‑debit notification sent <24 h before debit violates mandate policy	groq	2026-08-25 22:02:13.559887+00
421	421	affordability	customer_temp	0.95	insufficient balance	groq	2026-08-25 22:02:13.559887+00
422	422	affordability	customer_structural	0.95	repeated insufficient balance	groq	2026-08-25 22:02:13.559887+00
423	423	technical	infra	0.95	UPI bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
424	424	technical	infra	0.95	UPI bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
425	425	technical	infra	0.9	QR scan timed out in‑store	groq	2026-08-25 22:02:13.559887+00
426	426	lifecycle	merchant	0.95	pre‑debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
427	427	technical	infra	0.95	UPI bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
428	428	technical	infra	0.95	issuer gateway 5xx error	groq	2026-08-25 22:02:13.559887+00
429	429	technical	infra	0.95	UPI bank timeout at PSP	groq	2026-08-25 22:02:13.559887+00
430	430	intent	merchant	0.9	session abandoned at fee reveal	groq	2026-08-25 22:02:13.559887+00
431	431	intent	customer_temp	0.9	QR scan timed out; user left without completing payment	groq	2026-08-25 22:02:13.559887+00
432	432	lifecycle	merchant	0.9	Pre‑debit notification sent less than 24 h before debit (mandate breach)	groq	2026-08-25 22:02:13.559887+00
433	433	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
434	434	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
435	435	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-25 22:02:13.559887+00
436	436	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
437	437	intent	customer_temp	0.9	QR scan timed out; user left without completing payment	groq	2026-08-25 22:02:13.559887+00
438	438	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
439	439	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-25 22:02:13.559887+00
440	440	lifecycle	customer_temp	0.9	Card on file has expired	groq	2026-08-25 22:02:13.559887+00
441	441	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
442	442	technical	infra	0.9	UPI request timed out at PSP/gateway	groq	2026-08-25 22:02:13.559887+00
443	443	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
444	444	intent	merchant	0.9	User abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
445	445	intent	merchant	0.9	User abandoned at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
446	446	lifecycle	merchant	0.9	Pre-debit notification sent <24h before debit	groq	2026-08-25 22:02:13.559887+00
447	447	technical	infra	0.9	UPI request timed out at PSP/gateway	groq	2026-08-25 22:02:13.559887+00
448	448	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-25 22:02:13.559887+00
449	449	affordability	customer_temp	0.9	Insufficient balance reported by bank	groq	2026-08-25 22:02:13.559887+00
450	450	technical	infra	0.9	UPI request timed out at PSP/gateway	groq	2026-08-25 22:02:13.559887+00
451	451	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-25 22:02:13.559887+00
452	452	lifecycle	merchant	0.9	pre-debit notification sent <24h	groq	2026-08-25 22:02:13.559887+00
453	453	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-25 22:02:13.559887+00
454	454	intent	customer_temp	0.9	user dropped at OTP	groq	2026-08-25 22:02:13.559887+00
455	455	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-25 22:02:13.559887+00
456	456	lifecycle	merchant	0.9	pre-debit notification sent <24h	groq	2026-08-25 22:02:13.559887+00
457	457	lifecycle	merchant	0.9	pre-debit notification sent <24h	groq	2026-08-25 22:02:13.559887+00
458	458	technical	infra	0.9	gateway returned 5xx error	groq	2026-08-25 22:02:13.559887+00
459	459	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-25 22:02:13.559887+00
460	460	intent	customer_temp	0.9	user dropped at OTP	groq	2026-08-25 22:02:13.559887+00
461	461	technical	infra	0.9	UPI timeout at PSP	groq	2026-08-25 22:02:13.559887+00
462	462	technical	infra	0.9	UPI timeout at PSP	groq	2026-08-25 22:02:13.559887+00
463	463	technical	infra	0.9	UPI timeout at PSP	groq	2026-08-25 22:02:13.559887+00
464	464	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-25 22:02:13.559887+00
465	465	intent	merchant	0.9	user abandoned at fee reveal	groq	2026-08-25 22:02:13.559887+00
466	466	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-25 22:02:13.559887+00
467	467	intent	customer_temp	0.9	user abandoned at OTP	groq	2026-08-25 22:02:13.559887+00
468	468	intent	customer_temp	0.9	user abandoned at OTP	groq	2026-08-25 22:02:13.559887+00
469	469	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-25 22:02:13.559887+00
470	470	intent	customer_temp	0.9	user abandoned at OTP	groq	2026-08-25 22:02:13.559887+00
471	471	affordability	customer_structural	0.96	repeated insufficient balance indicates structural affordability issue	groq	2026-08-25 22:02:13.559887+00
472	472	affordability	customer_structural	0.96	repeated insufficient balance indicates structural affordability issue	groq	2026-08-25 22:02:13.559887+00
473	473	lifecycle	customer_temp	0.95	card expired on file	groq	2026-08-25 22:02:13.559887+00
474	474	intent	customer_temp	0.94	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
475	475	intent	merchant	0.92	fee shock caused abandonment at fee reveal	groq	2026-08-25 22:02:13.559887+00
476	476	technical	merchant	0.93	merchant checkout misconfiguration rejected payload	groq	2026-08-25 22:02:13.559887+00
477	477	intent	customer_temp	0.94	user dropped at OTP step	groq	2026-08-25 22:02:13.559887+00
478	478	technical	merchant	0.93	merchant checkout misconfiguration rejected payload	groq	2026-08-25 22:02:13.559887+00
479	479	intent	merchant	0.92	fee shock caused abandonment at fee reveal	groq	2026-08-25 22:02:13.559887+00
480	480	technical	infra	0.96	UPI request timed out at PSP (bank/server degradation)	groq	2026-08-25 22:02:13.559887+00
481	481	technical	infra	0.9	bank/PSP timeout	groq	2026-08-25 22:02:13.559887+00
482	482	affordability	customer_temp	0.9	insufficient balance reported by bank	groq	2026-08-25 22:02:13.559887+00
483	483	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
484	484	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-25 22:02:13.559887+00
485	485	affordability	customer_temp	0.9	insufficient balance reported by bank	groq	2026-08-25 22:02:13.559887+00
486	486	intent	customer_temp	0.9	QR scan timed out, customer left before completing payment	groq	2026-08-25 22:02:13.559887+00
487	487	intent	customer_temp	0.9	QR scan timed out, customer left before completing payment	groq	2026-08-25 22:02:13.559887+00
488	488	affordability	customer_temp	0.9	insufficient balance reported by bank	groq	2026-08-25 22:02:13.559887+00
489	489	affordability	customer_temp	0.9	insufficient balance reported by bank	groq	2026-08-25 22:02:13.559887+00
490	490	intent	merchant	0.9	merchant checkout misconfiguration rejected payment payload	groq	2026-08-25 22:02:13.559887+00
491	491	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
492	492	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-25 22:02:13.559887+00
493	493	affordability	customer_structural	0.9	Repeated insufficient‑balance declines over consecutive cycles	groq	2026-08-25 22:02:13.559887+00
494	494	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-25 22:02:13.559887+00
495	495	affordability	customer_structural	0.9	Repeated insufficient‑balance declines over consecutive cycles	groq	2026-08-25 22:02:13.559887+00
496	496	intent	customer_temp	0.9	QR scan timed out and customer left before completion	groq	2026-08-25 22:02:13.559887+00
497	497	lifecycle	customer_temp	0.9	Card on file has expired	groq	2026-08-25 22:02:13.559887+00
498	498	lifecycle	merchant	0.9	Pre‑debit notification sent less than 24 h before debit	groq	2026-08-25 22:02:13.559887+00
499	499	intent	merchant	0.9	User abandoned session at fee reveal (fee shock)	groq	2026-08-25 22:02:13.559887+00
500	500	intent	customer_temp	0.9	User dropped at OTP verification step	groq	2026-08-25 22:02:13.559887+00
\.


--
-- Data for Name: gate_decisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gate_decisions (id, failure_id, rule_id, verdict, context_snapshot, created_at) FROM stdin;
1	1	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
2	2	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
3	3	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
4	4	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
5	5	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
6	6	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
7	7	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
8	8	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
9	9	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
10	10	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
11	11	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
12	12	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
13	13	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
14	14	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
15	15	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
16	16	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
17	17	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
18	18	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
19	19	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
20	20	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
21	21	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
22	22	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
23	23	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
24	24	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
25	25	R07_OFFLINE_QR_TRAP	BLOCK	\N	2026-08-25 22:12:52.883864+00
26	26	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
27	27	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
28	28	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
29	29	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
30	30	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
31	31	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
32	32	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
33	33	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
34	34	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
35	35	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
36	36	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
37	37	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
38	38	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
39	39	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
40	40	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
41	41	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
42	42	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
43	43	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
44	44	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
45	45	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
46	46	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
47	47	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
48	48	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
49	49	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
50	50	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
51	51	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
52	52	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
53	53	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
54	54	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
55	55	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
56	56	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
57	57	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
58	58	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
59	59	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
60	60	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
61	61	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
62	62	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
63	63	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
64	64	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
65	65	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
66	66	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
67	67	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
68	68	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
69	69	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
70	70	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
71	71	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
72	72	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
73	73	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
74	74	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
75	75	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
76	76	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
77	77	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
78	78	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
79	79	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
80	80	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
81	81	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
82	82	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
83	83	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
84	84	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
85	85	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
86	86	R07_OFFLINE_QR_TRAP	BLOCK	\N	2026-08-25 22:12:52.883864+00
87	87	R07_OFFLINE_QR_TRAP	BLOCK	\N	2026-08-25 22:12:52.883864+00
88	88	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
89	89	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
90	90	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
91	91	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
92	92	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
93	93	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
94	94	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
95	95	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
96	96	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
97	97	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
98	98	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
99	99	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
100	100	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
101	101	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
102	102	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
103	103	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
104	104	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
105	105	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
106	106	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
107	107	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
108	108	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
109	109	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
110	110	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
111	111	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
112	112	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
113	113	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
114	114	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
115	115	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
116	116	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
117	117	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
118	118	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
119	119	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
120	120	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
121	121	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
122	122	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
123	123	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
124	124	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
125	125	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
126	126	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
127	127	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
128	128	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
129	129	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
130	130	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
131	131	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
132	132	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
133	133	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
134	134	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
135	135	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
136	136	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
137	137	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
138	138	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
139	139	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
140	140	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
141	141	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
142	142	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
143	143	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
144	144	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
145	145	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
146	146	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
147	147	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
148	148	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
149	149	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
150	150	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
151	151	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
152	152	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
153	153	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
154	154	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
155	155	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
156	156	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
157	157	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
158	158	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
159	159	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
160	160	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
161	161	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
162	162	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
163	163	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
164	164	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
165	165	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
166	166	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
167	167	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
168	168	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
169	169	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
170	170	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
171	171	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
172	172	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
173	173	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
174	174	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
175	175	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
176	176	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
177	177	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
178	178	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
179	179	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
180	180	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
181	181	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
182	182	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
183	183	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
184	184	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
185	185	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
186	186	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
187	187	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
188	188	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
189	189	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
190	190	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
191	191	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
192	192	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
193	193	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
194	194	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
195	195	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
196	196	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
197	197	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
198	198	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
199	199	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
200	200	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
201	201	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
202	202	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
203	203	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
204	204	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
205	205	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
206	206	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
207	207	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
208	208	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
209	209	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
210	210	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
211	211	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
212	212	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
213	213	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
214	214	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
215	215	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
216	216	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
217	217	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
218	218	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
219	219	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
220	220	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
221	221	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
222	222	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
223	223	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
224	224	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
225	225	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
226	226	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
227	227	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
228	228	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
229	229	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
230	230	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
231	231	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
232	232	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
233	233	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
234	234	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
235	235	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
236	236	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
237	237	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
238	238	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
239	239	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
240	240	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
241	241	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
242	242	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
243	243	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
244	244	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
245	245	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
246	246	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
247	247	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
248	248	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
249	249	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
250	250	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
251	251	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
252	252	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
253	253	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
254	254	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
255	255	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
256	256	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
257	257	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
258	258	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
259	259	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
260	260	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
261	261	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
262	262	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
263	263	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
264	264	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
265	265	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
266	266	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
267	267	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
268	268	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
269	269	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
270	270	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
271	271	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
272	272	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
273	273	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
274	274	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
275	275	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
276	276	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
277	277	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
278	278	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
279	279	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
280	280	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
281	281	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
282	282	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
283	283	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
284	284	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
285	285	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
286	286	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
287	287	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
288	288	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
289	289	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
290	290	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
291	291	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
292	292	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
293	293	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
294	294	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
295	295	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
296	296	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
297	297	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
298	298	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
299	299	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
300	300	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
301	301	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
302	302	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
303	303	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
304	304	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
305	305	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
306	306	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
307	307	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
308	308	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
309	309	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
310	310	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
311	311	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
312	312	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
313	313	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
314	314	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
315	315	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
316	316	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
317	317	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
318	318	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
319	319	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
320	320	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
321	321	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
322	322	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
323	323	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
324	324	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
325	325	R07_OFFLINE_QR_TRAP	BLOCK	\N	2026-08-25 22:12:52.883864+00
326	326	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
327	327	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
328	328	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
329	329	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
330	330	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
331	331	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
332	332	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
333	333	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
334	334	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
335	335	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
336	336	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
337	337	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
338	338	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
339	339	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
340	340	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
341	341	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
342	342	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
343	343	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
344	344	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
345	345	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
346	346	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
347	347	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
348	348	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
349	349	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
350	350	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
351	351	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
352	352	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
353	353	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
354	354	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
355	355	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
356	356	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
357	357	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
358	358	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
359	359	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
360	360	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
361	361	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
362	362	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
363	363	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
364	364	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
365	365	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
366	366	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
367	367	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
368	368	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
369	369	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
370	370	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
371	371	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
372	372	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
373	373	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
374	374	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
375	375	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
376	376	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
377	377	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
378	378	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
379	379	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
380	380	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
381	381	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
382	382	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
383	383	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
384	384	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
385	385	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
386	386	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
387	387	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
388	388	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
389	389	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
390	390	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
391	391	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
392	392	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
393	393	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
394	394	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
395	395	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
396	396	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
397	397	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
398	398	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
399	399	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
400	400	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
401	401	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
402	402	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
403	403	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
404	404	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
405	405	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
406	406	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
407	407	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
408	408	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
409	409	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
410	410	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
411	411	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
412	412	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
413	413	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
414	414	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
415	415	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
416	416	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
417	417	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
418	418	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
419	419	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
420	420	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
421	421	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
422	422	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
423	423	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
424	424	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
425	425	R07_OFFLINE_QR_TRAP	BLOCK	\N	2026-08-25 22:12:52.883864+00
426	426	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
427	427	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
428	428	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
429	429	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
430	430	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
431	431	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
432	432	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
433	433	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
434	434	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
435	435	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
436	436	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
437	437	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
438	438	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
439	439	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
440	440	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
441	441	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
442	442	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
443	443	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
444	444	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
445	445	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
446	446	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
447	447	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
448	448	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
449	449	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
450	450	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
451	451	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
452	452	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
453	453	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
454	454	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
455	455	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
456	456	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
457	457	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
458	458	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
459	459	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
460	460	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
461	461	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
462	462	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
463	463	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
464	464	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
465	465	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
466	466	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
467	467	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
468	468	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
469	469	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
470	470	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
471	471	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
472	472	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
473	473	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
474	474	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
475	475	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
476	476	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
477	477	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
478	478	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
479	479	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
480	480	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
481	481	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
482	482	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
483	483	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
484	484	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
485	485	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
486	486	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
487	487	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
488	488	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
489	489	R04_LIQUIDITY_DEFER	DEFER	\N	2026-08-25 22:12:52.883864+00
490	490	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
491	491	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
492	492	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
493	493	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
494	494	R05_TECH_RETRY	ALLOW	\N	2026-08-25 22:12:52.883864+00
495	495	R03_STRUCTURAL_STOP	BLOCK	\N	2026-08-25 22:12:52.883864+00
496	496	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
497	497	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
498	498	R01_RBI_MANDATE	BLOCK	\N	2026-08-25 22:12:52.883864+00
499	499	R02_FEE_SHOCK	BLOCK	\N	2026-08-25 22:12:52.883864+00
500	500	R06_DEFAULT_ALLOW	ALLOW	\N	2026-08-25 22:12:52.883864+00
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, failure_id, kind, run_at, attempts, max_attempts, status, last_error) FROM stdin;
1	11	DEFERRED_RETRY	2026-09-02 17:28:00+00	0	3	queued	\N
2	12	DEFERRED_RETRY	2026-09-02 16:32:00+00	0	3	queued	\N
3	21	DEFERRED_RETRY	2026-09-03 08:42:00+00	0	3	queued	\N
4	33	DEFERRED_RETRY	2026-09-04 19:21:00+00	0	3	queued	\N
5	39	DEFERRED_RETRY	2026-09-04 08:46:00+00	0	3	queued	\N
6	49	DEFERRED_RETRY	2026-09-01 16:29:00+00	0	3	queued	\N
7	51	DEFERRED_RETRY	2026-09-04 21:44:00+00	0	3	queued	\N
8	55	DEFERRED_RETRY	2026-09-03 15:38:00+00	0	3	queued	\N
9	66	DEFERRED_RETRY	2026-09-02 11:08:00+00	0	3	queued	\N
10	82	DEFERRED_RETRY	2026-09-03 15:39:00+00	0	3	queued	\N
11	111	DEFERRED_RETRY	2026-09-03 12:24:00+00	0	3	queued	\N
12	112	DEFERRED_RETRY	2026-09-04 19:04:00+00	0	3	queued	\N
13	121	DEFERRED_RETRY	2026-09-02 13:38:00+00	0	3	queued	\N
14	133	DEFERRED_RETRY	2026-09-02 18:06:00+00	0	3	queued	\N
15	139	DEFERRED_RETRY	2026-09-01 12:09:00+00	0	3	queued	\N
16	149	DEFERRED_RETRY	2026-09-02 12:53:00+00	0	3	queued	\N
17	151	DEFERRED_RETRY	2026-09-03 20:32:00+00	0	3	queued	\N
18	155	DEFERRED_RETRY	2026-09-04 10:01:00+00	0	3	queued	\N
19	166	DEFERRED_RETRY	2026-09-03 13:51:00+00	0	3	queued	\N
20	169	DEFERRED_RETRY	2026-09-03 09:48:00+00	0	3	queued	\N
21	182	DEFERRED_RETRY	2026-09-02 10:36:00+00	0	3	queued	\N
22	185	DEFERRED_RETRY	2026-09-04 16:49:00+00	0	3	queued	\N
23	188	DEFERRED_RETRY	2026-08-31 19:45:00+00	0	3	queued	\N
24	189	DEFERRED_RETRY	2026-09-04 17:54:00+00	0	3	queued	\N
25	211	DEFERRED_RETRY	2026-09-01 11:03:00+00	0	3	queued	\N
26	212	DEFERRED_RETRY	2026-09-04 15:55:00+00	0	3	queued	\N
27	221	DEFERRED_RETRY	2026-09-04 11:08:00+00	0	3	queued	\N
28	233	DEFERRED_RETRY	2026-09-03 21:32:00+00	0	3	queued	\N
29	239	DEFERRED_RETRY	2026-09-02 19:35:00+00	0	3	queued	\N
30	249	DEFERRED_RETRY	2026-09-01 09:58:00+00	0	3	queued	\N
31	251	DEFERRED_RETRY	2026-09-02 08:19:00+00	0	3	queued	\N
32	255	DEFERRED_RETRY	2026-08-31 17:36:00+00	0	3	queued	\N
33	266	DEFERRED_RETRY	2026-09-01 12:10:00+00	0	3	queued	\N
34	282	DEFERRED_RETRY	2026-08-31 22:38:00+00	0	3	queued	\N
35	285	DEFERRED_RETRY	2026-09-04 15:19:00+00	0	3	queued	\N
36	288	DEFERRED_RETRY	2026-09-03 19:41:00+00	0	3	queued	\N
37	289	DEFERRED_RETRY	2026-09-02 21:09:00+00	0	3	queued	\N
38	311	DEFERRED_RETRY	2026-09-03 08:34:00+00	0	3	queued	\N
39	312	DEFERRED_RETRY	2026-08-31 16:34:00+00	0	3	queued	\N
40	321	DEFERRED_RETRY	2026-09-02 10:43:00+00	0	3	queued	\N
41	333	DEFERRED_RETRY	2026-09-02 12:05:00+00	0	3	queued	\N
42	339	DEFERRED_RETRY	2026-08-31 21:17:00+00	0	3	queued	\N
43	349	DEFERRED_RETRY	2026-09-02 21:43:00+00	0	3	queued	\N
44	351	DEFERRED_RETRY	2026-09-03 22:38:00+00	0	3	queued	\N
45	355	DEFERRED_RETRY	2026-09-03 08:06:00+00	0	3	queued	\N
46	366	DEFERRED_RETRY	2026-09-03 20:00:00+00	0	3	queued	\N
47	369	DEFERRED_RETRY	2026-09-02 18:38:00+00	0	3	queued	\N
48	382	DEFERRED_RETRY	2026-09-03 23:35:00+00	0	3	queued	\N
49	385	DEFERRED_RETRY	2026-09-01 11:47:00+00	0	3	queued	\N
50	388	DEFERRED_RETRY	2026-09-04 13:39:00+00	0	3	queued	\N
51	389	DEFERRED_RETRY	2026-09-01 19:34:00+00	0	3	queued	\N
52	411	DEFERRED_RETRY	2026-09-01 08:39:00+00	0	3	queued	\N
53	421	DEFERRED_RETRY	2026-09-03 08:37:00+00	0	3	queued	\N
54	433	DEFERRED_RETRY	2026-09-03 19:03:00+00	0	3	queued	\N
55	439	DEFERRED_RETRY	2026-09-02 09:11:00+00	0	3	queued	\N
56	449	DEFERRED_RETRY	2026-09-02 10:37:00+00	0	3	queued	\N
57	451	DEFERRED_RETRY	2026-08-31 12:15:00+00	0	3	queued	\N
58	455	DEFERRED_RETRY	2026-09-03 19:49:00+00	0	3	queued	\N
59	466	DEFERRED_RETRY	2026-08-31 21:11:00+00	0	3	queued	\N
60	482	DEFERRED_RETRY	2026-08-31 14:51:00+00	0	3	queued	\N
61	485	DEFERRED_RETRY	2026-09-02 19:45:00+00	0	3	queued	\N
62	488	DEFERRED_RETRY	2026-09-04 15:42:00+00	0	3	queued	\N
63	489	DEFERRED_RETRY	2026-09-03 17:08:00+00	0	3	queued	\N
\.


--
-- Data for Name: merchant_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.merchant_config (id, merchant_id, pre_debit_notification_hours, billing_day, fee_reveal_at_checkout) FROM stdin;
1	merch_001	24	1	f
2	merch_002	12	1	f
3	merch_003	24	5	t
4	merch_004	24	1	f
5	merch_005	20	15	f
\.


--
-- Data for Name: payment_failures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_failures (id, external_payment_id, source, amount_paise, currency, method, failure_code, failure_description, customer_id, merchant_id, context, session_active, dropped_step, archetype, owner, confidence, true_archetype, true_owner, status, amount_recovered_paise, amount_protected_paise, occurred_at, created_at) FROM stdin;
73	pay_sim_0072	synthetic	170300	INR	card	CARD_EXPIRED	Card on file expired	cust_051	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	170300	0	2026-08-04 22:05:00+00	2026-08-25 22:02:11.364515+00
140	pay_sim_0139	synthetic	97700	INR	card	CARD_EXPIRED	Card on file expired	cust_010	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	97700	0	2026-08-17 09:42:00+00	2026-08-25 22:02:11.364515+00
158	pay_sim_0157	synthetic	66300	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_080	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	66300	0	2026-08-04 23:38:00+00	2026-08-25 22:02:11.364515+00
240	pay_sim_0239	synthetic	114700	INR	card	CARD_EXPIRED	Card on file expired	cust_036	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	114700	0	2026-08-19 20:57:00+00	2026-08-25 22:02:11.364515+00
283	pay_sim_0282	synthetic	51100	INR	card	CARD_EXPIRED	Card on file expired	cust_007	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	51100	0	2026-08-13 22:14:00+00	2026-08-25 22:02:11.364515+00
284	pay_sim_0283	synthetic	61100	INR	card	CARD_EXPIRED	Card on file expired	cust_070	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	61100	0	2026-08-05 17:14:00+00	2026-08-25 22:02:11.364515+00
440	pay_sim_0439	synthetic	52500	INR	card	CARD_EXPIRED	Card on file expired	cust_029	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	52500	0	2026-08-13 10:56:00+00	2026-08-25 22:02:11.364515+00
1	pay_sim_0000	synthetic	111900	INR	card	CARD_EXPIRED	Card on file expired	cust_011	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	111900	0	2026-08-18 21:38:00+00	2026-08-25 22:02:11.364515+00
2	pay_sim_0001	synthetic	199700	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_077	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	199700	2026-08-25 20:28:00+00	2026-08-25 22:02:11.364515+00
3	pay_sim_0002	synthetic	497000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_057	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	497000	0	2026-08-14 17:36:00+00	2026-08-25 22:02:11.364515+00
4	pay_sim_0003	synthetic	96100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_080	merch_001	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	96100	0	2026-08-25 14:40:00+00	2026-08-25 22:02:11.364515+00
5	pay_sim_0004	synthetic	81400	INR	card	CARD_EXPIRED	Card on file expired	cust_028	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	81400	0	2026-08-06 15:11:00+00	2026-08-25 22:02:11.364515+00
6	pay_sim_0005	synthetic	143100	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_071	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	143100	2026-08-01 21:28:00+00	2026-08-25 22:02:11.364515+00
7	pay_sim_0006	synthetic	253400	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_077	merch_004	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	253400	0	2026-08-02 15:18:00+00	2026-08-25 22:02:11.364515+00
8	pay_sim_0007	synthetic	73200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_037	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	73200	2026-08-22 15:59:00+00	2026-08-25 22:02:11.364515+00
9	pay_sim_0008	synthetic	176900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_034	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	176900	2026-08-14 11:34:00+00	2026-08-25 22:02:11.364515+00
10	pay_sim_0009	synthetic	232500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_029	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	232500	2026-08-27 12:04:00+00	2026-08-25 22:02:11.364515+00
11	pay_sim_0010	synthetic	481100	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_008	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	481100	2026-08-26 17:28:00+00	2026-08-25 22:02:11.364515+00
12	pay_sim_0011	synthetic	344600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_016	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	344600	2026-08-26 16:32:00+00	2026-08-25 22:02:11.364515+00
13	pay_sim_0012	synthetic	373500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_070	merch_004	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	373500	0	2026-08-03 09:56:00+00	2026-08-25 22:02:11.364515+00
14	pay_sim_0013	synthetic	220000	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_056	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	220000	0	2026-08-01 10:14:00+00	2026-08-25 22:02:11.364515+00
15	pay_sim_0014	synthetic	235600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_074	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	235600	2026-08-19 09:48:00+00	2026-08-25 22:02:11.364515+00
16	pay_sim_0015	synthetic	440000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_023	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	440000	0	2026-08-21 22:58:00+00	2026-08-25 22:02:11.364515+00
17	pay_sim_0016	synthetic	494400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_036	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	494400	0	2026-08-14 23:05:00+00	2026-08-25 22:02:11.364515+00
18	pay_sim_0017	synthetic	349400	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_061	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	349400	0	2026-08-11 18:42:00+00	2026-08-25 22:02:11.364515+00
19	pay_sim_0018	synthetic	285000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_014	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	285000	0	2026-08-14 23:18:00+00	2026-08-25 22:02:11.364515+00
20	pay_sim_0019	synthetic	387400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_052	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	387400	2026-08-03 18:16:00+00	2026-08-25 22:02:11.364515+00
21	pay_sim_0020	synthetic	436400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_042	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	436400	2026-08-27 08:42:00+00	2026-08-25 22:02:11.364515+00
22	pay_sim_0021	synthetic	353400	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_070	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	353400	2026-08-02 14:33:00+00	2026-08-25 22:02:11.364515+00
23	pay_sim_0022	synthetic	423200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_047	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	423200	0	2026-08-21 22:48:00+00	2026-08-25 22:02:11.364515+00
24	pay_sim_0023	synthetic	233600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_007	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	233600	0	2026-08-18 12:59:00+00	2026-08-25 22:02:11.364515+00
25	pay_sim_0024	synthetic	411900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_037	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	411900	2026-08-04 08:40:00+00	2026-08-25 22:02:11.364515+00
26	pay_sim_0025	synthetic	269400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_078	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	269400	2026-08-18 08:35:00+00	2026-08-25 22:02:11.364515+00
27	pay_sim_0026	synthetic	198900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_053	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	198900	0	2026-08-27 11:29:00+00	2026-08-25 22:02:11.364515+00
28	pay_sim_0027	synthetic	423100	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_016	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	423100	0	2026-08-23 17:32:00+00	2026-08-25 22:02:11.364515+00
29	pay_sim_0028	synthetic	410100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_035	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	410100	0	2026-08-16 15:29:00+00	2026-08-25 22:02:11.364515+00
30	pay_sim_0029	synthetic	329100	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_071	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	329100	2026-08-07 12:55:00+00	2026-08-25 22:02:11.364515+00
31	pay_sim_0030	synthetic	354800	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_009	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	354800	0	2026-08-11 16:52:00+00	2026-08-25 22:02:11.364515+00
32	pay_sim_0031	synthetic	495700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_001	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	495700	2026-08-19 23:55:00+00	2026-08-25 22:02:11.364515+00
33	pay_sim_0032	synthetic	411600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_020	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	411600	2026-08-28 19:21:00+00	2026-08-25 22:02:11.364515+00
34	pay_sim_0033	synthetic	323900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_071	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	323900	0	2026-08-15 18:55:00+00	2026-08-25 22:02:11.364515+00
35	pay_sim_0034	synthetic	483300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_025	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	483300	0	2026-08-13 15:54:00+00	2026-08-25 22:02:11.364515+00
36	pay_sim_0035	synthetic	275500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_053	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	275500	0	2026-08-24 23:45:00+00	2026-08-25 22:02:11.364515+00
37	pay_sim_0036	synthetic	139500	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_049	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	139500	0	2026-08-16 09:08:00+00	2026-08-25 22:02:11.364515+00
38	pay_sim_0037	synthetic	286800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_065	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	286800	0	2026-08-28 11:55:00+00	2026-08-25 22:02:11.364515+00
39	pay_sim_0038	synthetic	389200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	389200	2026-08-28 08:46:00+00	2026-08-25 22:02:11.364515+00
40	pay_sim_0039	synthetic	141300	INR	card	CARD_EXPIRED	Card on file expired	cust_019	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	141300	0	2026-08-03 23:50:00+00	2026-08-25 22:02:11.364515+00
41	pay_sim_0040	synthetic	340500	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_034	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	340500	0	2026-08-21 10:54:00+00	2026-08-25 22:02:11.364515+00
42	pay_sim_0041	synthetic	326200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_043	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	326200	0	2026-08-11 23:55:00+00	2026-08-25 22:02:11.364515+00
43	pay_sim_0042	synthetic	70900	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_070	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	70900	0	2026-08-08 17:14:00+00	2026-08-25 22:02:11.364515+00
44	pay_sim_0043	synthetic	95500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_012	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	95500	2026-08-25 11:28:00+00	2026-08-25 22:02:11.364515+00
45	pay_sim_0044	synthetic	38600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_022	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	38600	2026-08-02 18:50:00+00	2026-08-25 22:02:11.364515+00
46	pay_sim_0045	synthetic	321900	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_008	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	321900	2026-08-14 12:15:00+00	2026-08-25 22:02:11.364515+00
47	pay_sim_0046	synthetic	478500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_068	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	478500	0	2026-08-22 13:10:00+00	2026-08-25 22:02:11.364515+00
48	pay_sim_0047	synthetic	328200	INR	card	CARD_EXPIRED	Card on file expired	cust_023	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	328200	0	2026-08-20 15:31:00+00	2026-08-25 22:02:11.364515+00
49	pay_sim_0048	synthetic	392600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_075	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	392600	2026-08-25 16:29:00+00	2026-08-25 22:02:11.364515+00
50	pay_sim_0049	synthetic	396000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_033	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	396000	0	2026-08-10 13:04:00+00	2026-08-25 22:02:11.364515+00
51	pay_sim_0050	synthetic	259900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	259900	2026-08-28 21:44:00+00	2026-08-25 22:02:11.364515+00
52	pay_sim_0051	synthetic	178000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_033	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	178000	2026-08-13 23:06:00+00	2026-08-25 22:02:11.364515+00
53	pay_sim_0052	synthetic	483400	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_031	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	483400	2026-08-12 17:44:00+00	2026-08-25 22:02:11.364515+00
54	pay_sim_0053	synthetic	339100	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_038	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	339100	0	2026-08-09 08:36:00+00	2026-08-25 22:02:11.364515+00
55	pay_sim_0054	synthetic	249300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_007	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	249300	2026-08-27 15:38:00+00	2026-08-25 22:02:11.364515+00
56	pay_sim_0055	synthetic	220200	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_046	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	220200	2026-08-22 12:40:00+00	2026-08-25 22:02:11.364515+00
57	pay_sim_0056	synthetic	376000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_013	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	376000	2026-08-02 19:46:00+00	2026-08-25 22:02:11.364515+00
58	pay_sim_0057	synthetic	256600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_017	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	256600	0	2026-08-11 21:11:00+00	2026-08-25 22:02:11.364515+00
59	pay_sim_0058	synthetic	456700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_026	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	456700	0	2026-08-12 16:53:00+00	2026-08-25 22:02:11.364515+00
60	pay_sim_0059	synthetic	409600	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_022	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	409600	0	2026-08-26 17:47:00+00	2026-08-25 22:02:11.364515+00
61	pay_sim_0060	synthetic	398500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_044	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	398500	0	2026-08-03 12:48:00+00	2026-08-25 22:02:11.364515+00
62	pay_sim_0061	synthetic	471400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_029	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	471400	0	2026-08-12 10:50:00+00	2026-08-25 22:02:11.364515+00
63	pay_sim_0062	synthetic	231500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_051	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	231500	0	2026-08-18 11:29:00+00	2026-08-25 22:02:11.364515+00
64	pay_sim_0063	synthetic	319200	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_048	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	319200	2026-08-04 15:30:00+00	2026-08-25 22:02:11.364515+00
65	pay_sim_0064	synthetic	474800	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_004	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	474800	2026-08-11 15:41:00+00	2026-08-25 22:02:11.364515+00
66	pay_sim_0065	synthetic	349300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_009	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	349300	2026-08-26 11:08:00+00	2026-08-25 22:02:11.364515+00
67	pay_sim_0066	synthetic	264200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_006	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	264200	0	2026-08-16 11:06:00+00	2026-08-25 22:02:11.364515+00
68	pay_sim_0067	synthetic	126000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_031	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	126000	0	2026-08-13 22:23:00+00	2026-08-25 22:02:11.364515+00
69	pay_sim_0068	synthetic	141400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_070	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	141400	2026-08-28 21:41:00+00	2026-08-25 22:02:11.364515+00
70	pay_sim_0069	synthetic	349200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_013	merch_004	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	349200	0	2026-08-09 09:44:00+00	2026-08-25 22:02:11.364515+00
71	pay_sim_0070	synthetic	378100	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_048	merch_002	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	378100	2026-08-15 15:54:00+00	2026-08-25 22:02:11.364515+00
72	pay_sim_0071	synthetic	315800	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_047	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	315800	2026-08-18 19:03:00+00	2026-08-25 22:02:11.364515+00
74	pay_sim_0073	synthetic	32300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_028	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	32300	0	2026-08-02 18:15:00+00	2026-08-25 22:02:11.364515+00
75	pay_sim_0074	synthetic	183000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_017	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	183000	2026-08-03 14:37:00+00	2026-08-25 22:02:11.364515+00
76	pay_sim_0075	synthetic	284000	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_028	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	284000	0	2026-08-25 12:50:00+00	2026-08-25 22:02:11.364515+00
77	pay_sim_0076	synthetic	242000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_077	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	242000	0	2026-08-28 12:08:00+00	2026-08-25 22:02:11.364515+00
78	pay_sim_0077	synthetic	157800	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_070	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	157800	0	2026-08-04 08:08:00+00	2026-08-25 22:02:11.364515+00
79	pay_sim_0078	synthetic	209800	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_002	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	209800	2026-08-19 18:01:00+00	2026-08-25 22:02:11.364515+00
80	pay_sim_0079	synthetic	57800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_023	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	57800	0	2026-08-05 21:33:00+00	2026-08-25 22:02:11.364515+00
81	pay_sim_0080	synthetic	405000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_015	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	405000	0	2026-08-15 19:32:00+00	2026-08-25 22:02:11.364515+00
82	pay_sim_0081	synthetic	427600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_076	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	427600	2026-08-27 15:39:00+00	2026-08-25 22:02:11.364515+00
83	pay_sim_0082	synthetic	261900	INR	card	CARD_EXPIRED	Card on file expired	cust_006	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	261900	0	2026-08-15 08:03:00+00	2026-08-25 22:02:11.364515+00
84	pay_sim_0083	synthetic	364100	INR	card	CARD_EXPIRED	Card on file expired	cust_062	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	364100	0	2026-08-22 11:31:00+00	2026-08-25 22:02:11.364515+00
85	pay_sim_0084	synthetic	278700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	278700	2026-08-24 12:04:00+00	2026-08-25 22:02:11.364515+00
86	pay_sim_0085	synthetic	494400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_017	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	494400	2026-08-18 18:24:00+00	2026-08-25 22:02:11.364515+00
87	pay_sim_0086	synthetic	256400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_077	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	256400	2026-08-15 21:06:00+00	2026-08-25 22:02:11.364515+00
88	pay_sim_0087	synthetic	367200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_015	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	367200	2026-08-25 22:56:00+00	2026-08-25 22:02:11.364515+00
89	pay_sim_0088	synthetic	386400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_030	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	386400	2026-08-26 20:26:00+00	2026-08-25 22:02:11.364515+00
90	pay_sim_0089	synthetic	364500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_013	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	364500	2026-08-11 16:23:00+00	2026-08-25 22:02:11.364515+00
91	pay_sim_0090	synthetic	69800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_020	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	69800	0	2026-08-03 10:05:00+00	2026-08-25 22:02:11.364515+00
92	pay_sim_0091	synthetic	320100	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_056	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	320100	0	2026-08-26 12:35:00+00	2026-08-25 22:02:11.364515+00
93	pay_sim_0092	synthetic	474900	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_008	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	474900	2026-08-18 18:42:00+00	2026-08-25 22:02:11.364515+00
94	pay_sim_0093	synthetic	304500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_016	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	304500	0	2026-08-28 21:55:00+00	2026-08-25 22:02:11.364515+00
95	pay_sim_0094	synthetic	270800	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_007	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	270800	2026-08-12 11:36:00+00	2026-08-25 22:02:11.364515+00
96	pay_sim_0095	synthetic	141600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_065	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	141600	0	2026-08-22 23:14:00+00	2026-08-25 22:02:11.364515+00
97	pay_sim_0096	synthetic	470500	INR	card	CARD_EXPIRED	Card on file expired	cust_014	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	470500	0	2026-08-12 11:48:00+00	2026-08-25 22:02:11.364515+00
98	pay_sim_0097	synthetic	366400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_036	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	366400	2026-08-28 08:38:00+00	2026-08-25 22:02:11.364515+00
99	pay_sim_0098	synthetic	162600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_035	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	162600	2026-08-09 17:58:00+00	2026-08-25 22:02:11.364515+00
100	pay_sim_0099	synthetic	19900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_044	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	19900	0	2026-08-06 12:36:00+00	2026-08-25 22:02:11.364515+00
101	pay_sim_0100	synthetic	131100	INR	card	CARD_EXPIRED	Card on file expired	cust_052	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	131100	0	2026-08-24 08:05:00+00	2026-08-25 22:02:11.364515+00
102	pay_sim_0101	synthetic	323000	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_068	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	323000	2026-08-14 22:21:00+00	2026-08-25 22:02:11.364515+00
103	pay_sim_0102	synthetic	270100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_021	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	270100	0	2026-08-24 18:49:00+00	2026-08-25 22:02:11.364515+00
104	pay_sim_0103	synthetic	84400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_073	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	84400	0	2026-08-02 12:10:00+00	2026-08-25 22:02:11.364515+00
105	pay_sim_0104	synthetic	81700	INR	card	CARD_EXPIRED	Card on file expired	cust_080	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	81700	0	2026-08-09 22:42:00+00	2026-08-25 22:02:11.364515+00
106	pay_sim_0105	synthetic	377000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_055	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	377000	2026-08-14 16:13:00+00	2026-08-25 22:02:11.364515+00
107	pay_sim_0106	synthetic	297600	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_066	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	297600	0	2026-08-14 11:18:00+00	2026-08-25 22:02:11.364515+00
108	pay_sim_0107	synthetic	446500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_076	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	446500	2026-08-22 17:02:00+00	2026-08-25 22:02:11.364515+00
109	pay_sim_0108	synthetic	59700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_029	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	59700	2026-08-01 14:19:00+00	2026-08-25 22:02:11.364515+00
110	pay_sim_0109	synthetic	224200	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_028	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	224200	2026-08-10 18:07:00+00	2026-08-25 22:02:11.364515+00
111	pay_sim_0110	synthetic	158800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_001	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	158800	2026-08-27 12:24:00+00	2026-08-25 22:02:11.364515+00
112	pay_sim_0111	synthetic	472600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_069	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	472600	2026-08-28 19:04:00+00	2026-08-25 22:02:11.364515+00
113	pay_sim_0112	synthetic	372200	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_051	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	372200	2026-08-01 22:58:00+00	2026-08-25 22:02:11.364515+00
114	pay_sim_0113	synthetic	486500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_010	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	486500	0	2026-08-14 20:45:00+00	2026-08-25 22:02:11.364515+00
115	pay_sim_0114	synthetic	346700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_054	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	346700	2026-08-01 18:10:00+00	2026-08-25 22:02:11.364515+00
116	pay_sim_0115	synthetic	311300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_080	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	311300	0	2026-08-03 21:54:00+00	2026-08-25 22:02:11.364515+00
117	pay_sim_0116	synthetic	371800	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_014	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	371800	0	2026-08-19 20:33:00+00	2026-08-25 22:02:11.364515+00
118	pay_sim_0117	synthetic	269000	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_011	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	269000	0	2026-08-24 18:14:00+00	2026-08-25 22:02:11.364515+00
119	pay_sim_0118	synthetic	77400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_043	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	77400	0	2026-08-17 11:33:00+00	2026-08-25 22:02:11.364515+00
120	pay_sim_0119	synthetic	302500	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_066	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	302500	2026-08-24 12:15:00+00	2026-08-25 22:02:11.364515+00
121	pay_sim_0120	synthetic	176500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_014	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	176500	2026-08-26 13:38:00+00	2026-08-25 22:02:11.364515+00
122	pay_sim_0121	synthetic	160000	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_020	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	160000	2026-08-25 23:29:00+00	2026-08-25 22:02:11.364515+00
123	pay_sim_0122	synthetic	382600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_073	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	382600	0	2026-08-22 18:55:00+00	2026-08-25 22:02:11.364515+00
124	pay_sim_0123	synthetic	375100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_041	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	375100	0	2026-08-03 23:28:00+00	2026-08-25 22:02:11.364515+00
125	pay_sim_0124	synthetic	499300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_039	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	499300	0	2026-08-02 19:32:00+00	2026-08-25 22:02:11.364515+00
126	pay_sim_0125	synthetic	385100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_010	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	385100	2026-08-02 09:23:00+00	2026-08-25 22:02:11.364515+00
127	pay_sim_0126	synthetic	88800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_037	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	88800	0	2026-08-20 20:29:00+00	2026-08-25 22:02:11.364515+00
128	pay_sim_0127	synthetic	48500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_075	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	48500	0	2026-08-15 14:20:00+00	2026-08-25 22:02:11.364515+00
129	pay_sim_0128	synthetic	425600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_078	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	425600	0	2026-08-05 09:28:00+00	2026-08-25 22:02:11.364515+00
130	pay_sim_0129	synthetic	83900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_014	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	83900	2026-08-17 13:02:00+00	2026-08-25 22:02:11.364515+00
131	pay_sim_0130	synthetic	374800	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_032	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	374800	0	2026-08-17 13:23:00+00	2026-08-25 22:02:11.364515+00
132	pay_sim_0131	synthetic	349700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_048	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	349700	2026-08-25 18:43:00+00	2026-08-25 22:02:11.364515+00
133	pay_sim_0132	synthetic	68800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_077	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	68800	2026-08-26 18:06:00+00	2026-08-25 22:02:11.364515+00
134	pay_sim_0133	synthetic	247600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_072	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	247600	0	2026-08-09 12:21:00+00	2026-08-25 22:02:11.364515+00
135	pay_sim_0134	synthetic	130700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_011	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	130700	0	2026-08-12 17:41:00+00	2026-08-25 22:02:11.364515+00
136	pay_sim_0135	synthetic	84300	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_051	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	84300	0	2026-08-10 20:41:00+00	2026-08-25 22:02:11.364515+00
137	pay_sim_0136	synthetic	446100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_043	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	446100	0	2026-08-03 21:32:00+00	2026-08-25 22:02:11.364515+00
138	pay_sim_0137	synthetic	311900	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_047	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	311900	0	2026-08-10 13:13:00+00	2026-08-25 22:02:11.364515+00
139	pay_sim_0138	synthetic	200400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_044	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	200400	2026-08-25 12:09:00+00	2026-08-25 22:02:11.364515+00
141	pay_sim_0140	synthetic	122200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_044	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	122200	0	2026-08-20 20:09:00+00	2026-08-25 22:02:11.364515+00
142	pay_sim_0141	synthetic	150500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_021	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	150500	0	2026-08-24 22:02:00+00	2026-08-25 22:02:11.364515+00
143	pay_sim_0142	synthetic	209400	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_053	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	209400	0	2026-08-15 17:48:00+00	2026-08-25 22:02:11.364515+00
144	pay_sim_0143	synthetic	452300	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_058	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	452300	2026-08-08 17:51:00+00	2026-08-25 22:02:11.364515+00
145	pay_sim_0144	synthetic	316200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_061	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	316200	2026-08-22 22:29:00+00	2026-08-25 22:02:11.364515+00
146	pay_sim_0145	synthetic	147600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_037	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	147600	2026-08-27 14:51:00+00	2026-08-25 22:02:11.364515+00
147	pay_sim_0146	synthetic	219700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_078	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	219700	0	2026-08-02 23:55:00+00	2026-08-25 22:02:11.364515+00
148	pay_sim_0147	synthetic	98900	INR	card	CARD_EXPIRED	Card on file expired	cust_048	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	98900	0	2026-08-23 11:18:00+00	2026-08-25 22:02:11.364515+00
149	pay_sim_0148	synthetic	382900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_011	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	382900	2026-08-26 12:53:00+00	2026-08-25 22:02:11.364515+00
150	pay_sim_0149	synthetic	196700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_056	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	196700	0	2026-08-27 22:56:00+00	2026-08-25 22:02:11.364515+00
151	pay_sim_0150	synthetic	58500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_045	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	58500	2026-08-27 20:32:00+00	2026-08-25 22:02:11.364515+00
152	pay_sim_0151	synthetic	81700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_048	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	81700	2026-08-12 15:01:00+00	2026-08-25 22:02:11.364515+00
153	pay_sim_0152	synthetic	289500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_041	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	289500	2026-08-26 12:08:00+00	2026-08-25 22:02:11.364515+00
154	pay_sim_0153	synthetic	401900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_005	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	401900	0	2026-08-23 12:48:00+00	2026-08-25 22:02:11.364515+00
155	pay_sim_0154	synthetic	19200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_061	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	19200	2026-08-28 10:01:00+00	2026-08-25 22:02:11.364515+00
156	pay_sim_0155	synthetic	464400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_033	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	464400	2026-08-24 21:07:00+00	2026-08-25 22:02:11.364515+00
157	pay_sim_0156	synthetic	114700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_037	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	114700	2026-08-02 15:26:00+00	2026-08-25 22:02:11.364515+00
159	pay_sim_0158	synthetic	437000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_069	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	437000	0	2026-08-19 15:45:00+00	2026-08-25 22:02:11.364515+00
160	pay_sim_0159	synthetic	366500	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_019	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	366500	0	2026-08-01 19:15:00+00	2026-08-25 22:02:11.364515+00
161	pay_sim_0160	synthetic	168300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_074	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	168300	0	2026-08-22 10:33:00+00	2026-08-25 22:02:11.364515+00
162	pay_sim_0161	synthetic	445800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_047	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	445800	0	2026-08-18 08:24:00+00	2026-08-25 22:02:11.364515+00
163	pay_sim_0162	synthetic	331800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_061	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	331800	0	2026-08-12 16:47:00+00	2026-08-25 22:02:11.364515+00
164	pay_sim_0163	synthetic	297300	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_003	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	297300	2026-08-08 11:49:00+00	2026-08-25 22:02:11.364515+00
165	pay_sim_0164	synthetic	124100	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_075	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	124100	2026-08-02 19:34:00+00	2026-08-25 22:02:11.364515+00
166	pay_sim_0165	synthetic	406900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_044	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	406900	2026-08-27 13:51:00+00	2026-08-25 22:02:11.364515+00
167	pay_sim_0166	synthetic	389800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_018	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	389800	0	2026-08-02 17:12:00+00	2026-08-25 22:02:11.364515+00
168	pay_sim_0167	synthetic	49200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_006	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	49200	0	2026-08-11 17:32:00+00	2026-08-25 22:02:11.364515+00
169	pay_sim_0168	synthetic	222400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_051	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	222400	2026-08-27 09:48:00+00	2026-08-25 22:02:11.364515+00
170	pay_sim_0169	synthetic	307300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_025	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	307300	0	2026-08-28 09:55:00+00	2026-08-25 22:02:11.364515+00
171	pay_sim_0170	synthetic	116800	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_043	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	116800	2026-08-26 19:27:00+00	2026-08-25 22:02:11.364515+00
172	pay_sim_0171	synthetic	331600	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_052	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	331600	2026-08-11 13:31:00+00	2026-08-25 22:02:11.364515+00
173	pay_sim_0172	synthetic	440200	INR	card	CARD_EXPIRED	Card on file expired	cust_064	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	440200	0	2026-08-09 10:46:00+00	2026-08-25 22:02:11.364515+00
174	pay_sim_0173	synthetic	367600	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_055	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	367600	0	2026-08-20 13:34:00+00	2026-08-25 22:02:11.364515+00
175	pay_sim_0174	synthetic	98900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_038	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	98900	2026-08-03 18:42:00+00	2026-08-25 22:02:11.364515+00
176	pay_sim_0175	synthetic	380100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_038	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	380100	0	2026-08-20 21:10:00+00	2026-08-25 22:02:11.364515+00
177	pay_sim_0176	synthetic	381100	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_057	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	381100	0	2026-08-02 19:39:00+00	2026-08-25 22:02:11.364515+00
178	pay_sim_0177	synthetic	61800	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_056	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	61800	0	2026-08-03 20:23:00+00	2026-08-25 22:02:11.364515+00
179	pay_sim_0178	synthetic	40400	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_066	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	40400	2026-08-05 22:02:00+00	2026-08-25 22:02:11.364515+00
180	pay_sim_0179	synthetic	208200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_017	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	208200	0	2026-08-25 19:23:00+00	2026-08-25 22:02:11.364515+00
181	pay_sim_0180	synthetic	41400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_050	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	41400	0	2026-08-20 12:43:00+00	2026-08-25 22:02:11.364515+00
182	pay_sim_0181	synthetic	378500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_058	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	378500	2026-08-26 10:36:00+00	2026-08-25 22:02:11.364515+00
183	pay_sim_0182	synthetic	315500	INR	card	CARD_EXPIRED	Card on file expired	cust_018	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	315500	0	2026-08-13 18:41:00+00	2026-08-25 22:02:11.364515+00
184	pay_sim_0183	synthetic	107800	INR	card	CARD_EXPIRED	Card on file expired	cust_036	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	107800	0	2026-08-01 13:31:00+00	2026-08-25 22:02:11.364515+00
185	pay_sim_0184	synthetic	111300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_067	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	111300	2026-08-28 16:49:00+00	2026-08-25 22:02:11.364515+00
186	pay_sim_0185	synthetic	190600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_034	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	190600	0	2026-08-20 17:44:00+00	2026-08-25 22:02:11.364515+00
187	pay_sim_0186	synthetic	115300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_063	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	115300	0	2026-08-05 10:28:00+00	2026-08-25 22:02:11.364515+00
188	pay_sim_0187	synthetic	276700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_023	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	276700	2026-08-24 19:45:00+00	2026-08-25 22:02:11.364515+00
189	pay_sim_0188	synthetic	252700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_009	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	252700	2026-08-28 17:54:00+00	2026-08-25 22:02:11.364515+00
190	pay_sim_0189	synthetic	311000	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_021	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	311000	2026-08-17 15:07:00+00	2026-08-25 22:02:11.364515+00
191	pay_sim_0190	synthetic	208800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_026	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	208800	0	2026-08-26 23:01:00+00	2026-08-25 22:02:11.364515+00
192	pay_sim_0191	synthetic	483700	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_047	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	483700	0	2026-08-12 22:51:00+00	2026-08-25 22:02:11.364515+00
193	pay_sim_0192	synthetic	85500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_071	merch_002	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	85500	2026-08-03 17:25:00+00	2026-08-25 22:02:11.364515+00
194	pay_sim_0193	synthetic	351400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_062	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	351400	0	2026-08-25 21:52:00+00	2026-08-25 22:02:11.364515+00
195	pay_sim_0194	synthetic	117500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_074	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	117500	2026-08-11 10:28:00+00	2026-08-25 22:02:11.364515+00
196	pay_sim_0195	synthetic	297100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_060	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	297100	0	2026-08-05 13:49:00+00	2026-08-25 22:02:11.364515+00
197	pay_sim_0196	synthetic	426800	INR	card	CARD_EXPIRED	Card on file expired	cust_017	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	426800	0	2026-08-28 09:53:00+00	2026-08-25 22:02:11.364515+00
198	pay_sim_0197	synthetic	264000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_016	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	264000	2026-08-06 13:20:00+00	2026-08-25 22:02:11.364515+00
199	pay_sim_0198	synthetic	439900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_029	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	439900	2026-08-10 10:16:00+00	2026-08-25 22:02:11.364515+00
200	pay_sim_0199	synthetic	239700	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_026	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	239700	0	2026-08-05 17:39:00+00	2026-08-25 22:02:11.364515+00
201	pay_sim_0200	synthetic	426600	INR	card	CARD_EXPIRED	Card on file expired	cust_069	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	426600	0	2026-08-21 13:37:00+00	2026-08-25 22:02:11.364515+00
202	pay_sim_0201	synthetic	155100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_075	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	155100	2026-08-22 18:53:00+00	2026-08-25 22:02:11.364515+00
203	pay_sim_0202	synthetic	38100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_073	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	38100	0	2026-08-03 09:41:00+00	2026-08-25 22:02:11.364515+00
204	pay_sim_0203	synthetic	187500	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_074	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	187500	0	2026-08-25 21:39:00+00	2026-08-25 22:02:11.364515+00
205	pay_sim_0204	synthetic	461800	INR	card	CARD_EXPIRED	Card on file expired	cust_004	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	461800	0	2026-08-10 17:30:00+00	2026-08-25 22:02:11.364515+00
206	pay_sim_0205	synthetic	258500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_032	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	258500	2026-08-15 10:44:00+00	2026-08-25 22:02:11.364515+00
207	pay_sim_0206	synthetic	375000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_008	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	375000	0	2026-08-14 23:29:00+00	2026-08-25 22:02:11.364515+00
208	pay_sim_0207	synthetic	132500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_027	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	132500	2026-08-11 18:46:00+00	2026-08-25 22:02:11.364515+00
209	pay_sim_0208	synthetic	122000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_045	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	122000	2026-08-25 19:32:00+00	2026-08-25 22:02:11.364515+00
210	pay_sim_0209	synthetic	276300	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_072	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	276300	2026-08-08 22:07:00+00	2026-08-25 22:02:11.364515+00
211	pay_sim_0210	synthetic	130300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_035	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	130300	2026-08-25 11:03:00+00	2026-08-25 22:02:11.364515+00
212	pay_sim_0211	synthetic	357400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_038	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	357400	2026-08-28 15:55:00+00	2026-08-25 22:02:11.364515+00
213	pay_sim_0212	synthetic	488100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_021	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	488100	0	2026-08-24 18:12:00+00	2026-08-25 22:02:11.364515+00
214	pay_sim_0213	synthetic	436500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_021	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	436500	0	2026-08-15 23:56:00+00	2026-08-25 22:02:11.364515+00
215	pay_sim_0214	synthetic	88600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_040	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	88600	2026-08-13 22:15:00+00	2026-08-25 22:02:11.364515+00
216	pay_sim_0215	synthetic	303900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_028	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	303900	0	2026-08-02 09:18:00+00	2026-08-25 22:02:11.364515+00
217	pay_sim_0216	synthetic	400400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_064	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	400400	0	2026-08-10 08:54:00+00	2026-08-25 22:02:11.364515+00
218	pay_sim_0217	synthetic	124600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_014	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	124600	0	2026-08-09 19:48:00+00	2026-08-25 22:02:11.364515+00
219	pay_sim_0218	synthetic	51900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_052	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	51900	0	2026-08-13 09:36:00+00	2026-08-25 22:02:11.364515+00
220	pay_sim_0219	synthetic	468100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_072	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	468100	2026-08-10 10:24:00+00	2026-08-25 22:02:11.364515+00
221	pay_sim_0220	synthetic	244000	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_065	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	244000	2026-08-28 11:08:00+00	2026-08-25 22:02:11.364515+00
222	pay_sim_0221	synthetic	320600	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_013	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	320600	2026-08-26 18:35:00+00	2026-08-25 22:02:11.364515+00
223	pay_sim_0222	synthetic	177900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_047	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	177900	0	2026-08-20 20:32:00+00	2026-08-25 22:02:11.364515+00
224	pay_sim_0223	synthetic	46700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_006	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	46700	0	2026-08-05 18:51:00+00	2026-08-25 22:02:11.364515+00
225	pay_sim_0224	synthetic	389200	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_061	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	389200	0	2026-08-05 12:20:00+00	2026-08-25 22:02:11.364515+00
226	pay_sim_0225	synthetic	336800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_079	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	336800	2026-08-20 17:37:00+00	2026-08-25 22:02:11.364515+00
227	pay_sim_0226	synthetic	432400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_044	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	432400	0	2026-08-18 23:45:00+00	2026-08-25 22:02:11.364515+00
228	pay_sim_0227	synthetic	403900	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_073	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	403900	0	2026-08-27 08:23:00+00	2026-08-25 22:02:11.364515+00
229	pay_sim_0228	synthetic	356100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_043	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	356100	0	2026-08-19 17:50:00+00	2026-08-25 22:02:11.364515+00
230	pay_sim_0229	synthetic	403600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_004	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	403600	2026-08-09 15:46:00+00	2026-08-25 22:02:11.364515+00
231	pay_sim_0230	synthetic	408400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_007	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	408400	0	2026-08-06 20:09:00+00	2026-08-25 22:02:11.364515+00
232	pay_sim_0231	synthetic	171100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_032	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	171100	2026-08-01 22:20:00+00	2026-08-25 22:02:11.364515+00
233	pay_sim_0232	synthetic	181900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_054	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	181900	2026-08-27 21:32:00+00	2026-08-25 22:02:11.364515+00
234	pay_sim_0233	synthetic	65900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_079	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	65900	0	2026-08-23 12:33:00+00	2026-08-25 22:02:11.364515+00
235	pay_sim_0234	synthetic	281100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_027	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	281100	0	2026-08-22 23:33:00+00	2026-08-25 22:02:11.364515+00
236	pay_sim_0235	synthetic	156700	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_049	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	156700	0	2026-08-15 18:34:00+00	2026-08-25 22:02:11.364515+00
237	pay_sim_0236	synthetic	411500	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_046	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	411500	0	2026-08-07 15:17:00+00	2026-08-25 22:02:11.364515+00
238	pay_sim_0237	synthetic	199100	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_072	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	199100	0	2026-08-10 17:45:00+00	2026-08-25 22:02:11.364515+00
239	pay_sim_0238	synthetic	407900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_027	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	407900	2026-08-26 19:35:00+00	2026-08-25 22:02:11.364515+00
241	pay_sim_0240	synthetic	134800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_051	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	134800	0	2026-08-10 09:18:00+00	2026-08-25 22:02:11.364515+00
242	pay_sim_0241	synthetic	377200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_011	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	377200	0	2026-08-21 16:47:00+00	2026-08-25 22:02:11.364515+00
243	pay_sim_0242	synthetic	180400	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_062	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	180400	0	2026-08-27 16:59:00+00	2026-08-25 22:02:11.364515+00
244	pay_sim_0243	synthetic	127300	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_072	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	127300	2026-08-04 15:15:00+00	2026-08-25 22:02:11.364515+00
245	pay_sim_0244	synthetic	199700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_007	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	199700	2026-08-21 15:03:00+00	2026-08-25 22:02:11.364515+00
246	pay_sim_0245	synthetic	401800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_013	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	401800	2026-08-04 12:00:00+00	2026-08-25 22:02:11.364515+00
247	pay_sim_0246	synthetic	348200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_071	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	348200	0	2026-08-21 23:30:00+00	2026-08-25 22:02:11.364515+00
248	pay_sim_0247	synthetic	278000	INR	card	CARD_EXPIRED	Card on file expired	cust_026	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	278000	0	2026-08-10 09:58:00+00	2026-08-25 22:02:11.364515+00
249	pay_sim_0248	synthetic	453200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_012	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	453200	2026-08-25 09:58:00+00	2026-08-25 22:02:11.364515+00
250	pay_sim_0249	synthetic	158900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_023	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	158900	0	2026-08-02 20:50:00+00	2026-08-25 22:02:11.364515+00
251	pay_sim_0250	synthetic	45500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_064	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	45500	2026-08-26 08:19:00+00	2026-08-25 22:02:11.364515+00
252	pay_sim_0251	synthetic	289300	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_073	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	289300	2026-08-10 22:41:00+00	2026-08-25 22:02:11.364515+00
253	pay_sim_0252	synthetic	419500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_070	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	419500	2026-08-05 22:17:00+00	2026-08-25 22:02:11.364515+00
254	pay_sim_0253	synthetic	285700	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_025	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	285700	0	2026-08-06 22:41:00+00	2026-08-25 22:02:11.364515+00
255	pay_sim_0254	synthetic	291000	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_033	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	291000	2026-08-24 17:36:00+00	2026-08-25 22:02:11.364515+00
256	pay_sim_0255	synthetic	365200	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_025	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	365200	2026-08-17 18:05:00+00	2026-08-25 22:02:11.364515+00
257	pay_sim_0256	synthetic	130000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_052	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	130000	2026-08-16 18:59:00+00	2026-08-25 22:02:11.364515+00
258	pay_sim_0257	synthetic	228500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_032	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	228500	0	2026-08-13 15:28:00+00	2026-08-25 22:02:11.364515+00
259	pay_sim_0258	synthetic	262200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_035	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	262200	0	2026-08-19 08:16:00+00	2026-08-25 22:02:11.364515+00
260	pay_sim_0259	synthetic	65700	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_047	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	65700	0	2026-08-22 11:29:00+00	2026-08-25 22:02:11.364515+00
261	pay_sim_0260	synthetic	347000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_040	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	347000	0	2026-08-22 17:44:00+00	2026-08-25 22:02:11.364515+00
262	pay_sim_0261	synthetic	315900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_016	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	315900	0	2026-08-20 15:14:00+00	2026-08-25 22:02:11.364515+00
263	pay_sim_0262	synthetic	140300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_018	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	140300	0	2026-08-15 19:26:00+00	2026-08-25 22:02:11.364515+00
264	pay_sim_0263	synthetic	217600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_071	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	217600	2026-08-22 10:33:00+00	2026-08-25 22:02:11.364515+00
265	pay_sim_0264	synthetic	311200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_058	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	311200	2026-08-03 11:03:00+00	2026-08-25 22:02:11.364515+00
266	pay_sim_0265	synthetic	484000	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_071	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	484000	2026-08-25 12:10:00+00	2026-08-25 22:02:11.364515+00
267	pay_sim_0266	synthetic	376800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_042	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	376800	0	2026-08-04 14:45:00+00	2026-08-25 22:02:11.364515+00
268	pay_sim_0267	synthetic	89300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_075	merch_004	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	89300	0	2026-08-17 22:51:00+00	2026-08-25 22:02:11.364515+00
269	pay_sim_0268	synthetic	435300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_008	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	435300	2026-08-25 21:29:00+00	2026-08-25 22:02:11.364515+00
270	pay_sim_0269	synthetic	472600	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_073	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	472600	0	2026-08-15 17:46:00+00	2026-08-25 22:02:11.364515+00
271	pay_sim_0270	synthetic	223300	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_003	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	223300	2026-08-27 08:47:00+00	2026-08-25 22:02:11.364515+00
272	pay_sim_0271	synthetic	74700	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_028	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	74700	2026-08-02 21:22:00+00	2026-08-25 22:02:11.364515+00
273	pay_sim_0272	synthetic	64200	INR	card	CARD_EXPIRED	Card on file expired	cust_009	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	64200	0	2026-08-03 23:02:00+00	2026-08-25 22:02:11.364515+00
274	pay_sim_0273	synthetic	162300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_037	merch_004	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	162300	0	2026-08-25 12:49:00+00	2026-08-25 22:02:11.364515+00
275	pay_sim_0274	synthetic	328200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_054	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	328200	2026-08-15 20:24:00+00	2026-08-25 22:02:11.364515+00
276	pay_sim_0275	synthetic	123800	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_011	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	123800	0	2026-08-21 19:07:00+00	2026-08-25 22:02:11.364515+00
277	pay_sim_0276	synthetic	336800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_023	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	336800	0	2026-08-17 12:46:00+00	2026-08-25 22:02:11.364515+00
278	pay_sim_0277	synthetic	33500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_029	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	33500	0	2026-08-10 22:43:00+00	2026-08-25 22:02:11.364515+00
279	pay_sim_0278	synthetic	450600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_070	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	450600	2026-08-13 15:15:00+00	2026-08-25 22:02:11.364515+00
280	pay_sim_0279	synthetic	141900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_059	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	141900	0	2026-08-09 14:59:00+00	2026-08-25 22:02:11.364515+00
281	pay_sim_0280	synthetic	358300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_015	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	358300	0	2026-08-20 08:15:00+00	2026-08-25 22:02:11.364515+00
282	pay_sim_0281	synthetic	42400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_027	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	42400	2026-08-24 22:38:00+00	2026-08-25 22:02:11.364515+00
285	pay_sim_0284	synthetic	277500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_074	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	277500	2026-08-28 15:19:00+00	2026-08-25 22:02:11.364515+00
286	pay_sim_0285	synthetic	195900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_019	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	195900	0	2026-08-14 17:17:00+00	2026-08-25 22:02:11.364515+00
287	pay_sim_0286	synthetic	499500	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_008	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	499500	0	2026-08-24 13:40:00+00	2026-08-25 22:02:11.364515+00
288	pay_sim_0287	synthetic	53300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_055	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	53300	2026-08-27 19:41:00+00	2026-08-25 22:02:11.364515+00
289	pay_sim_0288	synthetic	355900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_049	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	355900	2026-08-26 21:09:00+00	2026-08-25 22:02:11.364515+00
290	pay_sim_0289	synthetic	165500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_039	merch_004	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	165500	2026-08-25 23:15:00+00	2026-08-25 22:02:11.364515+00
291	pay_sim_0290	synthetic	133100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_029	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	133100	0	2026-08-26 22:58:00+00	2026-08-25 22:02:11.364515+00
292	pay_sim_0291	synthetic	352900	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_008	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	352900	0	2026-08-14 12:24:00+00	2026-08-25 22:02:11.364515+00
293	pay_sim_0292	synthetic	181400	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_032	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	181400	2026-08-11 10:59:00+00	2026-08-25 22:02:11.364515+00
294	pay_sim_0293	synthetic	90600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_058	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	90600	0	2026-08-18 14:03:00+00	2026-08-25 22:02:11.364515+00
295	pay_sim_0294	synthetic	47200	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_035	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	47200	2026-08-28 10:12:00+00	2026-08-25 22:02:11.364515+00
296	pay_sim_0295	synthetic	192600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_076	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	192600	0	2026-08-16 14:55:00+00	2026-08-25 22:02:11.364515+00
297	pay_sim_0296	synthetic	27400	INR	card	CARD_EXPIRED	Card on file expired	cust_043	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	27400	0	2026-08-07 14:47:00+00	2026-08-25 22:02:11.364515+00
298	pay_sim_0297	synthetic	182400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_016	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	182400	2026-08-13 15:35:00+00	2026-08-25 22:02:11.364515+00
299	pay_sim_0298	synthetic	326700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_042	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	326700	2026-08-15 19:19:00+00	2026-08-25 22:02:11.364515+00
300	pay_sim_0299	synthetic	434900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_034	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	434900	0	2026-08-16 22:06:00+00	2026-08-25 22:02:11.364515+00
301	pay_sim_0300	synthetic	181300	INR	card	CARD_EXPIRED	Card on file expired	cust_061	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	181300	0	2026-08-12 18:26:00+00	2026-08-25 22:02:11.364515+00
302	pay_sim_0301	synthetic	196100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_006	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	196100	2026-08-24 12:01:00+00	2026-08-25 22:02:11.364515+00
303	pay_sim_0302	synthetic	493300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_034	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	493300	0	2026-08-19 21:18:00+00	2026-08-25 22:02:11.364515+00
304	pay_sim_0303	synthetic	285100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_020	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	285100	0	2026-08-08 20:36:00+00	2026-08-25 22:02:11.364515+00
305	pay_sim_0304	synthetic	465900	INR	card	CARD_EXPIRED	Card on file expired	cust_032	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	465900	0	2026-08-21 18:16:00+00	2026-08-25 22:02:11.364515+00
306	pay_sim_0305	synthetic	392400	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_063	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	392400	2026-08-06 19:10:00+00	2026-08-25 22:02:11.364515+00
307	pay_sim_0306	synthetic	414900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_018	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	414900	0	2026-08-06 09:33:00+00	2026-08-25 22:02:11.364515+00
308	pay_sim_0307	synthetic	54600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_005	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	54600	2026-08-25 08:26:00+00	2026-08-25 22:02:11.364515+00
309	pay_sim_0308	synthetic	70500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_018	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	70500	2026-08-23 12:00:00+00	2026-08-25 22:02:11.364515+00
310	pay_sim_0309	synthetic	388400	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_028	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	388400	2026-08-12 09:39:00+00	2026-08-25 22:02:11.364515+00
311	pay_sim_0310	synthetic	27700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_079	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	27700	2026-08-27 08:34:00+00	2026-08-25 22:02:11.364515+00
312	pay_sim_0311	synthetic	28600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_071	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	28600	2026-08-24 16:34:00+00	2026-08-25 22:02:11.364515+00
313	pay_sim_0312	synthetic	426300	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_037	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	426300	2026-08-27 21:51:00+00	2026-08-25 22:02:11.364515+00
314	pay_sim_0313	synthetic	93800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_023	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	93800	0	2026-08-17 12:15:00+00	2026-08-25 22:02:11.364515+00
315	pay_sim_0314	synthetic	305200	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_025	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	305200	2026-08-09 20:05:00+00	2026-08-25 22:02:11.364515+00
316	pay_sim_0315	synthetic	390900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_048	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	390900	0	2026-08-19 15:44:00+00	2026-08-25 22:02:11.364515+00
317	pay_sim_0316	synthetic	80900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_029	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	80900	0	2026-08-21 09:05:00+00	2026-08-25 22:02:11.364515+00
318	pay_sim_0317	synthetic	323800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_052	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	323800	0	2026-08-18 23:03:00+00	2026-08-25 22:02:11.364515+00
319	pay_sim_0318	synthetic	82600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_002	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	82600	0	2026-08-16 21:41:00+00	2026-08-25 22:02:11.364515+00
320	pay_sim_0319	synthetic	447500	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_043	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	447500	2026-08-02 15:13:00+00	2026-08-25 22:02:11.364515+00
321	pay_sim_0320	synthetic	53000	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_073	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	53000	2026-08-26 10:43:00+00	2026-08-25 22:02:11.364515+00
322	pay_sim_0321	synthetic	476500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_036	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	476500	2026-08-22 09:11:00+00	2026-08-25 22:02:11.364515+00
323	pay_sim_0322	synthetic	184600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_041	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	184600	0	2026-08-19 12:48:00+00	2026-08-25 22:02:11.364515+00
324	pay_sim_0323	synthetic	260000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_051	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	260000	0	2026-08-06 15:36:00+00	2026-08-25 22:02:11.364515+00
325	pay_sim_0324	synthetic	286600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_050	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	286600	2026-08-13 12:50:00+00	2026-08-25 22:02:11.364515+00
326	pay_sim_0325	synthetic	58800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_011	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	58800	2026-08-04 21:14:00+00	2026-08-25 22:02:11.364515+00
327	pay_sim_0326	synthetic	339800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_010	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	339800	0	2026-08-25 18:01:00+00	2026-08-25 22:02:11.364515+00
328	pay_sim_0327	synthetic	416800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_035	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	416800	0	2026-08-08 19:35:00+00	2026-08-25 22:02:11.364515+00
329	pay_sim_0328	synthetic	167000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_049	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	167000	0	2026-08-22 20:05:00+00	2026-08-25 22:02:11.364515+00
330	pay_sim_0329	synthetic	216700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_080	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	216700	2026-08-23 10:05:00+00	2026-08-25 22:02:11.364515+00
331	pay_sim_0330	synthetic	326100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_035	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	326100	0	2026-08-23 12:47:00+00	2026-08-25 22:02:11.364515+00
332	pay_sim_0331	synthetic	102100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_050	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	102100	2026-08-03 08:19:00+00	2026-08-25 22:02:11.364515+00
333	pay_sim_0332	synthetic	98600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	98600	2026-08-26 12:05:00+00	2026-08-25 22:02:11.364515+00
334	pay_sim_0333	synthetic	382500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_024	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	382500	0	2026-08-18 21:06:00+00	2026-08-25 22:02:11.364515+00
335	pay_sim_0334	synthetic	304800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_004	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	304800	0	2026-08-18 10:38:00+00	2026-08-25 22:02:11.364515+00
336	pay_sim_0335	synthetic	330400	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_077	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	330400	0	2026-08-01 17:26:00+00	2026-08-25 22:02:11.364515+00
337	pay_sim_0336	synthetic	473200	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_050	merch_001	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	473200	0	2026-08-08 13:43:00+00	2026-08-25 22:02:11.364515+00
338	pay_sim_0337	synthetic	128600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_049	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	128600	0	2026-08-09 17:17:00+00	2026-08-25 22:02:11.364515+00
339	pay_sim_0338	synthetic	151800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_064	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	151800	2026-08-24 21:17:00+00	2026-08-25 22:02:11.364515+00
340	pay_sim_0339	synthetic	411500	INR	card	CARD_EXPIRED	Card on file expired	cust_054	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	411500	0	2026-08-26 10:23:00+00	2026-08-25 22:02:11.364515+00
341	pay_sim_0340	synthetic	421000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_033	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	421000	0	2026-08-20 14:29:00+00	2026-08-25 22:02:11.364515+00
342	pay_sim_0341	synthetic	264400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_014	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	264400	0	2026-08-01 20:21:00+00	2026-08-25 22:02:11.364515+00
343	pay_sim_0342	synthetic	284800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_080	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	284800	0	2026-08-15 18:27:00+00	2026-08-25 22:02:11.364515+00
344	pay_sim_0343	synthetic	261000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_077	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	261000	2026-08-11 14:30:00+00	2026-08-25 22:02:11.364515+00
345	pay_sim_0344	synthetic	341100	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_041	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	341100	2026-08-11 17:47:00+00	2026-08-25 22:02:11.364515+00
346	pay_sim_0345	synthetic	281800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_063	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	281800	2026-08-13 16:52:00+00	2026-08-25 22:02:11.364515+00
347	pay_sim_0346	synthetic	108100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_051	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	108100	0	2026-08-19 14:37:00+00	2026-08-25 22:02:11.364515+00
348	pay_sim_0347	synthetic	465500	INR	card	CARD_EXPIRED	Card on file expired	cust_070	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	465500	0	2026-08-01 22:45:00+00	2026-08-25 22:02:11.364515+00
349	pay_sim_0348	synthetic	71500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_027	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	71500	2026-08-26 21:43:00+00	2026-08-25 22:02:11.364515+00
350	pay_sim_0349	synthetic	262900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_064	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	262900	0	2026-08-08 16:42:00+00	2026-08-25 22:02:11.364515+00
351	pay_sim_0350	synthetic	75400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_020	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	75400	2026-08-27 22:38:00+00	2026-08-25 22:02:11.364515+00
352	pay_sim_0351	synthetic	452600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_062	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	452600	2026-08-17 21:34:00+00	2026-08-25 22:02:11.364515+00
353	pay_sim_0352	synthetic	454700	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_005	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	454700	2026-08-20 10:06:00+00	2026-08-25 22:02:11.364515+00
354	pay_sim_0353	synthetic	151100	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_032	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	151100	0	2026-08-21 09:36:00+00	2026-08-25 22:02:11.364515+00
355	pay_sim_0354	synthetic	101600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_052	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	101600	2026-08-27 08:06:00+00	2026-08-25 22:02:11.364515+00
356	pay_sim_0355	synthetic	380000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_034	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	380000	2026-08-12 20:29:00+00	2026-08-25 22:02:11.364515+00
357	pay_sim_0356	synthetic	297400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_076	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	297400	2026-08-01 23:06:00+00	2026-08-25 22:02:11.364515+00
358	pay_sim_0357	synthetic	85200	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_038	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	85200	0	2026-08-04 12:22:00+00	2026-08-25 22:02:11.364515+00
359	pay_sim_0358	synthetic	387900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_040	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	387900	0	2026-08-26 14:33:00+00	2026-08-25 22:02:11.364515+00
360	pay_sim_0359	synthetic	404900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_062	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	404900	0	2026-08-04 22:46:00+00	2026-08-25 22:02:11.364515+00
361	pay_sim_0360	synthetic	69900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_058	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	69900	0	2026-08-10 09:51:00+00	2026-08-25 22:02:11.364515+00
362	pay_sim_0361	synthetic	295900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_015	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	295900	0	2026-08-21 11:43:00+00	2026-08-25 22:02:11.364515+00
363	pay_sim_0362	synthetic	437600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_022	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	437600	0	2026-08-06 13:21:00+00	2026-08-25 22:02:11.364515+00
364	pay_sim_0363	synthetic	204800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_072	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	204800	2026-08-26 20:40:00+00	2026-08-25 22:02:11.364515+00
365	pay_sim_0364	synthetic	368900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_024	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	368900	2026-08-13 08:47:00+00	2026-08-25 22:02:11.364515+00
366	pay_sim_0365	synthetic	366700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_079	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	366700	2026-08-27 20:00:00+00	2026-08-25 22:02:11.364515+00
367	pay_sim_0366	synthetic	242900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_028	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	242900	0	2026-08-25 10:36:00+00	2026-08-25 22:02:11.364515+00
368	pay_sim_0367	synthetic	168000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_014	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	168000	0	2026-08-12 18:12:00+00	2026-08-25 22:02:11.364515+00
369	pay_sim_0368	synthetic	415800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_059	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	415800	2026-08-26 18:38:00+00	2026-08-25 22:02:11.364515+00
370	pay_sim_0369	synthetic	336400	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_050	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	336400	0	2026-08-19 11:22:00+00	2026-08-25 22:02:11.364515+00
371	pay_sim_0370	synthetic	156200	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_046	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	156200	2026-08-27 17:58:00+00	2026-08-25 22:02:11.364515+00
372	pay_sim_0371	synthetic	84300	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_079	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	84300	2026-08-22 12:20:00+00	2026-08-25 22:02:11.364515+00
373	pay_sim_0372	synthetic	265000	INR	card	CARD_EXPIRED	Card on file expired	cust_016	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	265000	0	2026-08-04 13:23:00+00	2026-08-25 22:02:11.364515+00
374	pay_sim_0373	synthetic	333100	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_019	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	333100	0	2026-08-14 12:36:00+00	2026-08-25 22:02:11.364515+00
375	pay_sim_0374	synthetic	167000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_050	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	167000	2026-08-16 13:35:00+00	2026-08-25 22:02:11.364515+00
376	pay_sim_0375	synthetic	251500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_022	merch_004	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	251500	0	2026-08-05 13:20:00+00	2026-08-25 22:02:11.364515+00
377	pay_sim_0376	synthetic	58800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_058	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	58800	0	2026-08-28 19:00:00+00	2026-08-25 22:02:11.364515+00
378	pay_sim_0377	synthetic	174700	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_063	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	174700	0	2026-08-27 20:35:00+00	2026-08-25 22:02:11.364515+00
379	pay_sim_0378	synthetic	350000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_065	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	350000	2026-08-22 23:26:00+00	2026-08-25 22:02:11.364515+00
380	pay_sim_0379	synthetic	151900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_057	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	151900	0	2026-08-03 08:50:00+00	2026-08-25 22:02:11.364515+00
381	pay_sim_0380	synthetic	41600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_029	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	41600	0	2026-08-09 15:34:00+00	2026-08-25 22:02:11.364515+00
382	pay_sim_0381	synthetic	478200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_037	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	478200	2026-08-27 23:35:00+00	2026-08-25 22:02:11.364515+00
383	pay_sim_0382	synthetic	484000	INR	card	CARD_EXPIRED	Card on file expired	cust_066	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	484000	0	2026-08-04 16:49:00+00	2026-08-25 22:02:11.364515+00
384	pay_sim_0383	synthetic	458900	INR	card	CARD_EXPIRED	Card on file expired	cust_070	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	458900	0	2026-08-27 09:48:00+00	2026-08-25 22:02:11.364515+00
385	pay_sim_0384	synthetic	363100	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	363100	2026-08-25 11:47:00+00	2026-08-25 22:02:11.364515+00
386	pay_sim_0385	synthetic	41300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_032	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	41300	0	2026-08-15 16:22:00+00	2026-08-25 22:02:11.364515+00
387	pay_sim_0386	synthetic	111000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_012	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	111000	0	2026-08-25 15:13:00+00	2026-08-25 22:02:11.364515+00
388	pay_sim_0387	synthetic	365600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_076	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	365600	2026-08-28 13:39:00+00	2026-08-25 22:02:11.364515+00
389	pay_sim_0388	synthetic	63500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_018	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	63500	2026-08-25 19:34:00+00	2026-08-25 22:02:11.364515+00
390	pay_sim_0389	synthetic	456200	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_036	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	456200	2026-08-06 18:45:00+00	2026-08-25 22:02:11.364515+00
391	pay_sim_0390	synthetic	484000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_038	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	484000	0	2026-08-09 11:08:00+00	2026-08-25 22:02:11.364515+00
392	pay_sim_0391	synthetic	242000	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_053	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	242000	0	2026-08-28 12:44:00+00	2026-08-25 22:02:11.364515+00
393	pay_sim_0392	synthetic	134700	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_017	merch_002	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	134700	2026-08-23 18:53:00+00	2026-08-25 22:02:11.364515+00
394	pay_sim_0393	synthetic	415800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_032	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	415800	0	2026-08-05 16:40:00+00	2026-08-25 22:02:11.364515+00
395	pay_sim_0394	synthetic	385100	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_054	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	385100	2026-08-03 10:25:00+00	2026-08-25 22:02:11.364515+00
396	pay_sim_0395	synthetic	317200	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_066	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	317200	0	2026-08-15 23:20:00+00	2026-08-25 22:02:11.364515+00
397	pay_sim_0396	synthetic	91200	INR	card	CARD_EXPIRED	Card on file expired	cust_075	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	91200	0	2026-08-24 22:40:00+00	2026-08-25 22:02:11.364515+00
398	pay_sim_0397	synthetic	193300	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_046	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	193300	2026-08-14 14:31:00+00	2026-08-25 22:02:11.364515+00
399	pay_sim_0398	synthetic	247200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_035	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	247200	2026-08-11 12:36:00+00	2026-08-25 22:02:11.364515+00
400	pay_sim_0399	synthetic	54500	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_063	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	54500	0	2026-08-02 11:40:00+00	2026-08-25 22:02:11.364515+00
401	pay_sim_0400	synthetic	116600	INR	card	CARD_EXPIRED	Card on file expired	cust_059	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	116600	0	2026-08-28 13:28:00+00	2026-08-25 22:02:11.364515+00
402	pay_sim_0401	synthetic	365300	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_059	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	365300	2026-08-07 12:56:00+00	2026-08-25 22:02:11.364515+00
403	pay_sim_0402	synthetic	239300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_039	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	239300	0	2026-08-03 19:16:00+00	2026-08-25 22:02:11.364515+00
404	pay_sim_0403	synthetic	150400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_011	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	150400	0	2026-08-02 20:40:00+00	2026-08-25 22:02:11.364515+00
405	pay_sim_0404	synthetic	366500	INR	card	CARD_EXPIRED	Card on file expired	cust_040	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	366500	0	2026-08-21 10:45:00+00	2026-08-25 22:02:11.364515+00
406	pay_sim_0405	synthetic	189700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_013	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	189700	2026-08-16 10:08:00+00	2026-08-25 22:02:11.364515+00
407	pay_sim_0406	synthetic	440400	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_076	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	440400	0	2026-08-22 22:00:00+00	2026-08-25 22:02:11.364515+00
408	pay_sim_0407	synthetic	113600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_002	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	113600	2026-08-28 21:44:00+00	2026-08-25 22:02:11.364515+00
409	pay_sim_0408	synthetic	72900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_017	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	72900	2026-08-08 20:05:00+00	2026-08-25 22:02:11.364515+00
410	pay_sim_0409	synthetic	271500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_014	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	271500	2026-08-12 17:08:00+00	2026-08-25 22:02:11.364515+00
411	pay_sim_0410	synthetic	70900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_049	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	70900	2026-08-25 08:39:00+00	2026-08-25 22:02:11.364515+00
412	pay_sim_0411	synthetic	189400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_022	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	189400	2026-08-26 12:58:00+00	2026-08-25 22:02:11.364515+00
413	pay_sim_0412	synthetic	377300	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_053	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	377300	0	2026-08-28 14:05:00+00	2026-08-25 22:02:11.364515+00
414	pay_sim_0413	synthetic	115700	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_013	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	115700	0	2026-08-19 20:22:00+00	2026-08-25 22:02:11.364515+00
415	pay_sim_0414	synthetic	217800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_055	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	217800	2026-08-09 10:15:00+00	2026-08-25 22:02:11.364515+00
416	pay_sim_0415	synthetic	248300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_071	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	248300	0	2026-08-25 08:54:00+00	2026-08-25 22:02:11.364515+00
417	pay_sim_0416	synthetic	439000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_039	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	439000	0	2026-08-20 14:47:00+00	2026-08-25 22:02:11.364515+00
418	pay_sim_0417	synthetic	59600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_051	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	59600	0	2026-08-26 15:31:00+00	2026-08-25 22:02:11.364515+00
419	pay_sim_0418	synthetic	212300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_050	merch_001	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	212300	0	2026-08-16 10:33:00+00	2026-08-25 22:02:11.364515+00
420	pay_sim_0419	synthetic	123000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_002	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	123000	2026-08-13 21:23:00+00	2026-08-25 22:02:11.364515+00
421	pay_sim_0420	synthetic	74600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_070	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	74600	2026-08-27 08:37:00+00	2026-08-25 22:02:11.364515+00
422	pay_sim_0421	synthetic	229600	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_009	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	229600	2026-08-07 09:59:00+00	2026-08-25 22:02:11.364515+00
423	pay_sim_0422	synthetic	429900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_008	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	429900	0	2026-08-10 21:27:00+00	2026-08-25 22:02:11.364515+00
424	pay_sim_0423	synthetic	454400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_052	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	454400	0	2026-08-18 12:17:00+00	2026-08-25 22:02:11.364515+00
425	pay_sim_0424	synthetic	79600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_011	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	79600	2026-08-17 14:51:00+00	2026-08-25 22:02:11.364515+00
426	pay_sim_0425	synthetic	334900	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_020	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	334900	2026-08-19 10:19:00+00	2026-08-25 22:02:11.364515+00
427	pay_sim_0426	synthetic	62300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_056	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	62300	0	2026-08-08 10:59:00+00	2026-08-25 22:02:11.364515+00
428	pay_sim_0427	synthetic	386300	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_056	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	386300	0	2026-08-20 09:19:00+00	2026-08-25 22:02:11.364515+00
429	pay_sim_0428	synthetic	25200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_023	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	25200	0	2026-08-23 12:44:00+00	2026-08-25 22:02:11.364515+00
430	pay_sim_0429	synthetic	421500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_002	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	421500	2026-08-12 16:10:00+00	2026-08-25 22:02:11.364515+00
431	pay_sim_0430	synthetic	235000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_048	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	235000	0	2026-08-24 11:49:00+00	2026-08-25 22:02:11.364515+00
432	pay_sim_0431	synthetic	237700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_004	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	237700	2026-08-17 10:16:00+00	2026-08-25 22:02:11.364515+00
433	pay_sim_0432	synthetic	387700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_074	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	387700	2026-08-27 19:03:00+00	2026-08-25 22:02:11.364515+00
434	pay_sim_0433	synthetic	151600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_064	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	151600	0	2026-08-12 13:16:00+00	2026-08-25 22:02:11.364515+00
435	pay_sim_0434	synthetic	109300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_014	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	109300	0	2026-08-08 08:02:00+00	2026-08-25 22:02:11.364515+00
436	pay_sim_0435	synthetic	52500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_002	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	52500	0	2026-08-16 19:24:00+00	2026-08-25 22:02:11.364515+00
437	pay_sim_0436	synthetic	43800	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_020	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	43800	0	2026-08-18 21:14:00+00	2026-08-25 22:02:11.364515+00
438	pay_sim_0437	synthetic	355800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_042	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	355800	0	2026-08-24 18:17:00+00	2026-08-25 22:02:11.364515+00
439	pay_sim_0438	synthetic	112700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_010	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	112700	2026-08-26 09:11:00+00	2026-08-25 22:02:11.364515+00
441	pay_sim_0440	synthetic	269400	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_060	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	269400	0	2026-08-11 10:35:00+00	2026-08-25 22:02:11.364515+00
442	pay_sim_0441	synthetic	317100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_059	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	317100	0	2026-08-07 17:36:00+00	2026-08-25 22:02:11.364515+00
443	pay_sim_0442	synthetic	213600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_039	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	213600	0	2026-08-15 19:37:00+00	2026-08-25 22:02:11.364515+00
444	pay_sim_0443	synthetic	462600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_064	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	462600	2026-08-25 15:09:00+00	2026-08-25 22:02:11.364515+00
445	pay_sim_0444	synthetic	34400	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_001	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	34400	2026-08-08 19:40:00+00	2026-08-25 22:02:11.364515+00
446	pay_sim_0445	synthetic	323100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_002	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	323100	2026-08-28 17:06:00+00	2026-08-25 22:02:11.364515+00
447	pay_sim_0446	synthetic	210000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_027	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	210000	0	2026-08-14 23:03:00+00	2026-08-25 22:02:11.364515+00
448	pay_sim_0447	synthetic	91100	INR	card	CARD_EXPIRED	Card on file expired	cust_019	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	91100	0	2026-08-02 15:57:00+00	2026-08-25 22:02:11.364515+00
449	pay_sim_0448	synthetic	390400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_067	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	390400	2026-08-26 10:37:00+00	2026-08-25 22:02:11.364515+00
450	pay_sim_0449	synthetic	124200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_013	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	124200	0	2026-08-21 20:04:00+00	2026-08-25 22:02:11.364515+00
451	pay_sim_0450	synthetic	371200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_076	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	371200	2026-08-24 12:15:00+00	2026-08-25 22:02:11.364515+00
452	pay_sim_0451	synthetic	336800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_038	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	336800	2026-08-23 18:20:00+00	2026-08-25 22:02:11.364515+00
453	pay_sim_0452	synthetic	206200	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_058	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	206200	2026-08-03 14:08:00+00	2026-08-25 22:02:11.364515+00
454	pay_sim_0453	synthetic	142200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_075	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	142200	0	2026-08-04 13:28:00+00	2026-08-25 22:02:11.364515+00
455	pay_sim_0454	synthetic	113800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_060	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	113800	2026-08-27 19:49:00+00	2026-08-25 22:02:11.364515+00
456	pay_sim_0455	synthetic	394400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_027	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	394400	2026-08-09 11:05:00+00	2026-08-25 22:02:11.364515+00
457	pay_sim_0456	synthetic	191000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_021	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	191000	2026-08-27 18:09:00+00	2026-08-25 22:02:11.364515+00
458	pay_sim_0457	synthetic	306300	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_012	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	306300	0	2026-08-13 09:43:00+00	2026-08-25 22:02:11.364515+00
459	pay_sim_0458	synthetic	157300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_039	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	157300	0	2026-08-01 20:54:00+00	2026-08-25 22:02:11.364515+00
460	pay_sim_0459	synthetic	465500	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_058	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	465500	0	2026-08-08 11:29:00+00	2026-08-25 22:02:11.364515+00
461	pay_sim_0460	synthetic	114300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_014	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	114300	0	2026-08-01 09:53:00+00	2026-08-25 22:02:11.364515+00
462	pay_sim_0461	synthetic	177200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_029	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	177200	0	2026-08-27 20:23:00+00	2026-08-25 22:02:11.364515+00
463	pay_sim_0462	synthetic	495000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_011	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	495000	0	2026-08-09 10:01:00+00	2026-08-25 22:02:11.364515+00
464	pay_sim_0463	synthetic	120400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_009	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	120400	2026-08-03 18:07:00+00	2026-08-25 22:02:11.364515+00
465	pay_sim_0464	synthetic	56300	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_006	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	56300	2026-08-06 21:52:00+00	2026-08-25 22:02:11.364515+00
466	pay_sim_0465	synthetic	328400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_051	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	328400	2026-08-24 21:11:00+00	2026-08-25 22:02:11.364515+00
467	pay_sim_0466	synthetic	168200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_046	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	168200	0	2026-08-09 16:28:00+00	2026-08-25 22:02:11.364515+00
468	pay_sim_0467	synthetic	216200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_020	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	216200	0	2026-08-21 17:31:00+00	2026-08-25 22:02:11.364515+00
469	pay_sim_0468	synthetic	64800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_053	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	64800	2026-08-27 10:17:00+00	2026-08-25 22:02:11.364515+00
470	pay_sim_0469	synthetic	358300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_050	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	358300	0	2026-08-07 15:40:00+00	2026-08-25 22:02:11.364515+00
471	pay_sim_0470	synthetic	328200	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_070	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	328200	2026-08-26 19:30:00+00	2026-08-25 22:02:11.364515+00
472	pay_sim_0471	synthetic	296700	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_070	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	296700	2026-08-19 18:24:00+00	2026-08-25 22:02:11.364515+00
473	pay_sim_0472	synthetic	36200	INR	card	CARD_EXPIRED	Card on file expired	cust_035	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	36200	0	2026-08-11 15:01:00+00	2026-08-25 22:02:11.364515+00
474	pay_sim_0473	synthetic	401300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_036	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	401300	0	2026-08-17 19:49:00+00	2026-08-25 22:02:11.364515+00
475	pay_sim_0474	synthetic	145600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_075	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	145600	2026-08-04 15:42:00+00	2026-08-25 22:02:11.364515+00
476	pay_sim_0475	synthetic	452000	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_031	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	452000	0	2026-08-27 09:48:00+00	2026-08-25 22:02:11.364515+00
477	pay_sim_0476	synthetic	333000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_029	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	333000	0	2026-08-12 13:11:00+00	2026-08-25 22:02:11.364515+00
478	pay_sim_0477	synthetic	275400	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_031	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	275400	0	2026-08-26 19:58:00+00	2026-08-25 22:02:11.364515+00
479	pay_sim_0478	synthetic	302900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_076	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	302900	2026-08-19 12:36:00+00	2026-08-25 22:02:11.364515+00
480	pay_sim_0479	synthetic	459000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_025	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	459000	0	2026-08-10 13:31:00+00	2026-08-25 22:02:11.364515+00
481	pay_sim_0480	synthetic	60900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_005	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	60900	0	2026-08-08 15:01:00+00	2026-08-25 22:02:11.364515+00
482	pay_sim_0481	synthetic	286600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_068	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	286600	2026-08-24 14:51:00+00	2026-08-25 22:02:11.364515+00
483	pay_sim_0482	synthetic	160200	INR	card	CARD_EXPIRED	Card on file expired	cust_017	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	160200	0	2026-08-26 18:03:00+00	2026-08-25 22:02:11.364515+00
484	pay_sim_0483	synthetic	495400	INR	card	CARD_EXPIRED	Card on file expired	cust_003	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	495400	0	2026-08-23 12:49:00+00	2026-08-25 22:02:11.364515+00
485	pay_sim_0484	synthetic	74300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_015	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	74300	2026-08-26 19:45:00+00	2026-08-25 22:02:11.364515+00
486	pay_sim_0485	synthetic	97600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_051	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	97600	0	2026-08-11 17:20:00+00	2026-08-25 22:02:11.364515+00
487	pay_sim_0486	synthetic	372700	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_018	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	372700	0	2026-08-26 23:41:00+00	2026-08-25 22:02:11.364515+00
488	pay_sim_0487	synthetic	307200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_041	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	307200	2026-08-28 15:42:00+00	2026-08-25 22:02:11.364515+00
489	pay_sim_0488	synthetic	266200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_076	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	266200	2026-08-27 17:08:00+00	2026-08-25 22:02:11.364515+00
490	pay_sim_0489	synthetic	484100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_023	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	0	484100	2026-08-13 09:11:00+00	2026-08-25 22:02:11.364515+00
491	pay_sim_0490	synthetic	195800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_078	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	195800	0	2026-08-21 11:59:00+00	2026-08-25 22:02:11.364515+00
492	pay_sim_0491	synthetic	286100	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_064	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	286100	0	2026-08-24 10:15:00+00	2026-08-25 22:02:11.364515+00
493	pay_sim_0492	synthetic	152400	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_045	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	152400	2026-08-21 10:52:00+00	2026-08-25 22:02:11.364515+00
494	pay_sim_0493	synthetic	24200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_043	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	24200	0	2026-08-09 14:15:00+00	2026-08-25 22:02:11.364515+00
495	pay_sim_0494	synthetic	225100	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_009	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	225100	2026-08-26 11:46:00+00	2026-08-25 22:02:11.364515+00
496	pay_sim_0495	synthetic	331000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_001	merch_001	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	331000	0	2026-08-15 21:10:00+00	2026-08-25 22:02:11.364515+00
497	pay_sim_0496	synthetic	325100	INR	card	CARD_EXPIRED	Card on file expired	cust_053	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	325100	0	2026-08-12 20:06:00+00	2026-08-25 22:02:11.364515+00
498	pay_sim_0497	synthetic	148100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_062	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	148100	2026-08-15 10:51:00+00	2026-08-25 22:02:11.364515+00
499	pay_sim_0498	synthetic	31300	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_005	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	31300	2026-08-11 16:06:00+00	2026-08-25 22:02:11.364515+00
500	pay_sim_0499	synthetic	154200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_010	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	154200	0	2026-08-13 13:46:00+00	2026-08-25 22:02:11.364515+00
\.


--
-- Data for Name: promises_to_pay; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promises_to_pay (id, failure_id, promised_date, amount_paise, status, created_at) FROM stdin;
\.


--
-- Data for Name: recovery_actions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recovery_actions (id, failure_id, action_type, actor, reasoning, status, amount_recovered_paise, executed_at) FROM stdin;
1	1	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	111900	2026-08-25 22:12:55.50892+00
2	2	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
3	3	RETRY_LINK	system	R05_TECH_RETRY	executed	497000	2026-08-25 22:12:55.50892+00
4	4	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	96100	2026-08-25 22:12:55.50892+00
5	5	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	81400	2026-08-25 22:12:55.50892+00
6	6	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
7	7	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/rzp/wDt3HjF | R06_DEFAULT_ALLOW	executed	253400	2026-08-25 22:12:55.50892+00
8	8	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
9	9	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
10	10	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
11	11	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
12	12	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
13	13	RETRY_LINK	system	R05_TECH_RETRY	executed	373500	2026-08-25 22:12:55.50892+00
14	14	RETRY_LINK	system	R05_TECH_RETRY	executed	220000	2026-08-25 22:12:55.50892+00
15	15	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
16	16	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	440000	2026-08-25 22:12:55.50892+00
17	17	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	494400	2026-08-25 22:12:55.50892+00
18	18	RETRY_LINK	system	R05_TECH_RETRY	executed	349400	2026-08-25 22:12:55.50892+00
19	19	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	285000	2026-08-25 22:12:55.50892+00
20	20	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
21	21	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
22	22	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
23	23	RETRY_LINK	system	R05_TECH_RETRY	executed	423200	2026-08-25 22:12:55.50892+00
24	24	RETRY_LINK	system	R05_TECH_RETRY	executed	233600	2026-08-25 22:12:55.50892+00
25	25	BLOCKED	system	R07_OFFLINE_QR_TRAP	blocked	0	2026-08-25 22:12:55.50892+00
26	26	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
27	27	RETRY_LINK	system	R05_TECH_RETRY	executed	198900	2026-08-25 22:12:55.50892+00
28	28	RETRY_LINK	system	R05_TECH_RETRY	executed	423100	2026-08-25 22:12:55.50892+00
29	29	RETRY_LINK	system	R05_TECH_RETRY	executed	410100	2026-08-25 22:12:55.50892+00
30	30	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
31	31	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	354800	2026-08-25 22:12:55.50892+00
32	32	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
33	33	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
34	34	RETRY_LINK	system	R05_TECH_RETRY	executed	323900	2026-08-25 22:12:55.50892+00
35	35	RETRY_LINK	system	R05_TECH_RETRY	executed	483300	2026-08-25 22:12:55.50892+00
36	36	RETRY_LINK	system	R05_TECH_RETRY	executed	275500	2026-08-25 22:12:55.50892+00
37	37	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	139500	2026-08-25 22:12:55.50892+00
38	38	RETRY_LINK	system	R05_TECH_RETRY	executed	286800	2026-08-25 22:12:55.50892+00
39	39	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
40	40	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	141300	2026-08-25 22:12:55.50892+00
41	41	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/rzp/PmaOHBm4 | R06_DEFAULT_ALLOW	executed	340500	2026-08-25 22:12:55.50892+00
42	42	RETRY_LINK	system	R05_TECH_RETRY	executed	326200	2026-08-25 22:12:55.50892+00
43	43	RETRY_LINK	system	R05_TECH_RETRY	executed	70900	2026-08-25 22:12:55.50892+00
44	44	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
45	45	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
46	46	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
47	47	RETRY_LINK	system	R05_TECH_RETRY	executed	478500	2026-08-25 22:12:55.50892+00
48	48	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	328200	2026-08-25 22:12:55.50892+00
49	49	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
50	50	RETRY_LINK	system	R05_TECH_RETRY	executed	396000	2026-08-25 22:12:55.50892+00
51	51	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
52	52	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
53	53	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
54	54	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/rzp/652SwK1R | R06_DEFAULT_ALLOW	executed	339100	2026-08-25 22:12:55.50892+00
55	55	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
56	56	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
57	57	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
58	58	RETRY_LINK	system	R05_TECH_RETRY	executed	256600	2026-08-25 22:12:55.50892+00
59	59	RETRY_LINK	system	R05_TECH_RETRY	executed	456700	2026-08-25 22:12:55.50892+00
60	60	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/rzp/T02HVNq | R06_DEFAULT_ALLOW	executed	409600	2026-08-25 22:12:55.50892+00
61	61	RETRY_LINK	system	R05_TECH_RETRY	executed	398500	2026-08-25 22:12:55.50892+00
62	62	RETRY_LINK	system	R05_TECH_RETRY	executed	471400	2026-08-25 22:12:55.50892+00
63	63	RETRY_LINK	system	R05_TECH_RETRY	executed	231500	2026-08-25 22:12:55.50892+00
64	64	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
65	65	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
66	66	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
67	67	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/rzp/08GIdaA | R06_DEFAULT_ALLOW	executed	264200	2026-08-25 22:12:55.50892+00
68	68	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	126000	2026-08-25 22:12:55.50892+00
69	69	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
70	70	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	349200	2026-08-25 22:12:55.50892+00
71	71	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
72	72	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
73	73	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	170300	2026-08-25 22:12:55.50892+00
74	74	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	32300	2026-08-25 22:12:55.50892+00
75	75	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
76	76	RETRY_LINK	system	R05_TECH_RETRY	executed	284000	2026-08-25 22:12:55.50892+00
77	77	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	242000	2026-08-25 22:12:55.50892+00
78	78	RETRY_LINK	system	R05_TECH_RETRY	executed	157800	2026-08-25 22:12:55.50892+00
79	79	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
80	80	RETRY_LINK	system	R05_TECH_RETRY	executed	57800	2026-08-25 22:12:55.50892+00
81	81	RETRY_LINK	system	R05_TECH_RETRY	executed	405000	2026-08-25 22:12:55.50892+00
82	82	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
83	83	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	261900	2026-08-25 22:12:55.50892+00
84	84	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	364100	2026-08-25 22:12:55.50892+00
85	85	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
86	86	BLOCKED	system	R07_OFFLINE_QR_TRAP	blocked	0	2026-08-25 22:12:55.50892+00
87	87	BLOCKED	system	R07_OFFLINE_QR_TRAP	blocked	0	2026-08-25 22:12:55.50892+00
88	88	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
89	89	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
90	90	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
91	91	RETRY_LINK	system	R05_TECH_RETRY	executed	69800	2026-08-25 22:12:55.50892+00
92	92	RETRY_LINK	system	R05_TECH_RETRY	executed	320100	2026-08-25 22:12:55.50892+00
93	93	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
94	94	RETRY_LINK	system	R05_TECH_RETRY	executed	304500	2026-08-25 22:12:55.50892+00
95	95	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
96	96	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	141600	2026-08-25 22:12:55.50892+00
97	97	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	470500	2026-08-25 22:12:55.50892+00
98	98	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
99	99	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
100	100	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	19900	2026-08-25 22:12:55.50892+00
101	101	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	131100	2026-08-25 22:12:55.50892+00
102	102	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
103	103	RETRY_LINK	system	R05_TECH_RETRY	executed	270100	2026-08-25 22:12:55.50892+00
104	104	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	84400	2026-08-25 22:12:55.50892+00
105	105	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	81700	2026-08-25 22:12:55.50892+00
106	106	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
107	107	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	297600	2026-08-25 22:12:55.50892+00
108	108	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
109	109	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
110	110	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
111	111	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
112	112	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
113	113	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
114	114	RETRY_LINK	system	R05_TECH_RETRY	executed	486500	2026-08-25 22:12:55.50892+00
115	115	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
116	116	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	311300	2026-08-25 22:12:55.50892+00
117	117	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	371800	2026-08-25 22:12:55.50892+00
118	118	RETRY_LINK	system	R05_TECH_RETRY	executed	269000	2026-08-25 22:12:55.50892+00
119	119	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	77400	2026-08-25 22:12:55.50892+00
120	120	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
121	121	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
122	122	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
123	123	RETRY_LINK	system	R05_TECH_RETRY	executed	382600	2026-08-25 22:12:55.50892+00
124	124	RETRY_LINK	system	R05_TECH_RETRY	executed	375100	2026-08-25 22:12:55.50892+00
125	125	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	499300	2026-08-25 22:12:55.50892+00
126	126	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
127	127	RETRY_LINK	system	R05_TECH_RETRY	executed	88800	2026-08-25 22:12:55.50892+00
128	128	RETRY_LINK	system	R05_TECH_RETRY	executed	48500	2026-08-25 22:12:55.50892+00
129	129	RETRY_LINK	system	R05_TECH_RETRY	executed	425600	2026-08-25 22:12:55.50892+00
130	130	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
131	131	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	374800	2026-08-25 22:12:55.50892+00
132	132	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
133	133	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
134	134	RETRY_LINK	system	R05_TECH_RETRY	executed	247600	2026-08-25 22:12:55.50892+00
135	135	RETRY_LINK	system	R05_TECH_RETRY	executed	130700	2026-08-25 22:12:55.50892+00
136	136	RETRY_LINK	system	R05_TECH_RETRY	executed	84300	2026-08-25 22:12:55.50892+00
137	137	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	446100	2026-08-25 22:12:55.50892+00
138	138	RETRY_LINK	system	R05_TECH_RETRY	executed	311900	2026-08-25 22:12:55.50892+00
139	139	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
140	140	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	97700	2026-08-25 22:12:55.50892+00
141	141	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	122200	2026-08-25 22:12:55.50892+00
142	142	RETRY_LINK	system	R05_TECH_RETRY	executed	150500	2026-08-25 22:12:55.50892+00
143	143	RETRY_LINK	system	R05_TECH_RETRY	executed	209400	2026-08-25 22:12:55.50892+00
144	144	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
145	145	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
146	146	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
147	147	RETRY_LINK	system	R05_TECH_RETRY	executed	219700	2026-08-25 22:12:55.50892+00
148	148	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	98900	2026-08-25 22:12:55.50892+00
149	149	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
150	150	RETRY_LINK	system	R05_TECH_RETRY	executed	196700	2026-08-25 22:12:55.50892+00
151	151	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
152	152	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
153	153	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
154	154	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	401900	2026-08-25 22:12:55.50892+00
155	155	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
156	156	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
157	157	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
158	158	RETRY_LINK	system	R05_TECH_RETRY	executed	66300	2026-08-25 22:12:55.50892+00
159	159	RETRY_LINK	system	R05_TECH_RETRY	executed	437000	2026-08-25 22:12:55.50892+00
160	160	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	366500	2026-08-25 22:12:55.50892+00
161	161	RETRY_LINK	system	R05_TECH_RETRY	executed	168300	2026-08-25 22:12:55.50892+00
162	162	RETRY_LINK	system	R05_TECH_RETRY	executed	445800	2026-08-25 22:12:55.50892+00
163	163	RETRY_LINK	system	R05_TECH_RETRY	executed	331800	2026-08-25 22:12:55.50892+00
164	164	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
165	165	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
166	166	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
167	167	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	389800	2026-08-25 22:12:55.50892+00
168	168	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	49200	2026-08-25 22:12:55.50892+00
169	169	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
170	170	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	307300	2026-08-25 22:12:55.50892+00
171	171	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
172	172	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
173	173	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	440200	2026-08-25 22:12:55.50892+00
174	174	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	367600	2026-08-25 22:12:55.50892+00
175	175	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
176	176	RETRY_LINK	system	R05_TECH_RETRY	executed	380100	2026-08-25 22:12:55.50892+00
177	177	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	381100	2026-08-25 22:12:55.50892+00
178	178	RETRY_LINK	system	R05_TECH_RETRY	executed	61800	2026-08-25 22:12:55.50892+00
179	179	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
180	180	RETRY_LINK	system	R05_TECH_RETRY	executed	208200	2026-08-25 22:12:55.50892+00
181	181	RETRY_LINK	system	R05_TECH_RETRY	executed	41400	2026-08-25 22:12:55.50892+00
182	182	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
183	183	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	315500	2026-08-25 22:12:55.50892+00
184	184	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	107800	2026-08-25 22:12:55.50892+00
185	185	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
186	186	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	190600	2026-08-25 22:12:55.50892+00
187	187	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	115300	2026-08-25 22:12:55.50892+00
188	188	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
189	189	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
190	190	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
191	191	RETRY_LINK	system	R05_TECH_RETRY	executed	208800	2026-08-25 22:12:55.50892+00
192	192	RETRY_LINK	system	R05_TECH_RETRY	executed	483700	2026-08-25 22:12:55.50892+00
193	193	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
194	194	RETRY_LINK	system	R05_TECH_RETRY	executed	351400	2026-08-25 22:12:55.50892+00
195	195	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
196	196	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	297100	2026-08-25 22:12:55.50892+00
197	197	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	426800	2026-08-25 22:12:55.50892+00
198	198	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
199	199	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
200	200	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	239700	2026-08-25 22:12:55.50892+00
201	201	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	426600	2026-08-25 22:12:55.50892+00
202	202	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
203	203	RETRY_LINK	system	R05_TECH_RETRY	executed	38100	2026-08-25 22:12:55.50892+00
204	204	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	187500	2026-08-25 22:12:55.50892+00
205	205	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	461800	2026-08-25 22:12:55.50892+00
206	206	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
207	207	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	375000	2026-08-25 22:12:55.50892+00
208	208	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
209	209	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
210	210	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
211	211	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
212	212	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
213	213	RETRY_LINK	system	R05_TECH_RETRY	executed	488100	2026-08-25 22:12:55.50892+00
214	214	RETRY_LINK	system	R05_TECH_RETRY	executed	436500	2026-08-25 22:12:55.50892+00
215	215	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
216	216	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	303900	2026-08-25 22:12:55.50892+00
217	217	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	400400	2026-08-25 22:12:55.50892+00
218	218	RETRY_LINK	system	R05_TECH_RETRY	executed	124600	2026-08-25 22:12:55.50892+00
219	219	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	51900	2026-08-25 22:12:55.50892+00
220	220	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
221	221	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
222	222	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
223	223	RETRY_LINK	system	R05_TECH_RETRY	executed	177900	2026-08-25 22:12:55.50892+00
224	224	RETRY_LINK	system	R05_TECH_RETRY	executed	46700	2026-08-25 22:12:55.50892+00
225	225	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	389200	2026-08-25 22:12:55.50892+00
226	226	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
227	227	RETRY_LINK	system	R05_TECH_RETRY	executed	432400	2026-08-25 22:12:55.50892+00
228	228	RETRY_LINK	system	R05_TECH_RETRY	executed	403900	2026-08-25 22:12:55.50892+00
229	229	RETRY_LINK	system	R05_TECH_RETRY	executed	356100	2026-08-25 22:12:55.50892+00
230	230	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
231	231	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	408400	2026-08-25 22:12:55.50892+00
232	232	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
233	233	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
234	234	RETRY_LINK	system	R05_TECH_RETRY	executed	65900	2026-08-25 22:12:55.50892+00
235	235	RETRY_LINK	system	R05_TECH_RETRY	executed	281100	2026-08-25 22:12:55.50892+00
236	236	RETRY_LINK	system	R05_TECH_RETRY	executed	156700	2026-08-25 22:12:55.50892+00
237	237	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	411500	2026-08-25 22:12:55.50892+00
238	238	RETRY_LINK	system	R05_TECH_RETRY	executed	199100	2026-08-25 22:12:55.50892+00
239	239	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
240	240	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	114700	2026-08-25 22:12:55.50892+00
241	241	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	134800	2026-08-25 22:12:55.50892+00
242	242	RETRY_LINK	system	R05_TECH_RETRY	executed	377200	2026-08-25 22:12:55.50892+00
243	243	RETRY_LINK	system	R05_TECH_RETRY	executed	180400	2026-08-25 22:12:55.50892+00
244	244	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
245	245	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
246	246	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
247	247	RETRY_LINK	system	R05_TECH_RETRY	executed	348200	2026-08-25 22:12:55.50892+00
248	248	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	278000	2026-08-25 22:12:55.50892+00
249	249	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
250	250	RETRY_LINK	system	R05_TECH_RETRY	executed	158900	2026-08-25 22:12:55.50892+00
251	251	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
252	252	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
253	253	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
254	254	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	285700	2026-08-25 22:12:55.50892+00
255	255	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
256	256	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
257	257	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
258	258	RETRY_LINK	system	R05_TECH_RETRY	executed	228500	2026-08-25 22:12:55.50892+00
259	259	RETRY_LINK	system	R05_TECH_RETRY	executed	262200	2026-08-25 22:12:55.50892+00
260	260	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	65700	2026-08-25 22:12:55.50892+00
261	261	RETRY_LINK	system	R05_TECH_RETRY	executed	347000	2026-08-25 22:12:55.50892+00
262	262	RETRY_LINK	system	R05_TECH_RETRY	executed	315900	2026-08-25 22:12:55.50892+00
263	263	RETRY_LINK	system	R05_TECH_RETRY	executed	140300	2026-08-25 22:12:55.50892+00
264	264	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
265	265	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
266	266	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
267	267	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	376800	2026-08-25 22:12:55.50892+00
268	268	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	89300	2026-08-25 22:12:55.50892+00
269	269	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
270	270	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	472600	2026-08-25 22:12:55.50892+00
271	271	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
272	272	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
273	273	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	64200	2026-08-25 22:12:55.50892+00
274	274	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	162300	2026-08-25 22:12:55.50892+00
275	275	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
276	276	RETRY_LINK	system	R05_TECH_RETRY	executed	123800	2026-08-25 22:12:55.50892+00
277	277	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	336800	2026-08-25 22:12:55.50892+00
278	278	RETRY_LINK	system	R05_TECH_RETRY	executed	33500	2026-08-25 22:12:55.50892+00
279	279	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
280	280	RETRY_LINK	system	R05_TECH_RETRY	executed	141900	2026-08-25 22:12:55.50892+00
281	281	RETRY_LINK	system	R05_TECH_RETRY	executed	358300	2026-08-25 22:12:55.50892+00
282	282	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
283	283	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	51100	2026-08-25 22:12:55.50892+00
284	284	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	61100	2026-08-25 22:12:55.50892+00
285	285	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
286	286	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	195900	2026-08-25 22:12:55.50892+00
287	287	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	499500	2026-08-25 22:12:55.50892+00
288	288	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
289	289	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
290	290	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
291	291	RETRY_LINK	system	R05_TECH_RETRY	executed	133100	2026-08-25 22:12:55.50892+00
292	292	RETRY_LINK	system	R05_TECH_RETRY	executed	352900	2026-08-25 22:12:55.50892+00
293	293	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
294	294	RETRY_LINK	system	R05_TECH_RETRY	executed	90600	2026-08-25 22:12:55.50892+00
295	295	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
296	296	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	192600	2026-08-25 22:12:55.50892+00
297	297	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	27400	2026-08-25 22:12:55.50892+00
298	298	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
299	299	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
450	450	RETRY_LINK	system	R05_TECH_RETRY	executed	124200	2026-08-25 22:12:55.50892+00
300	300	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	434900	2026-08-25 22:12:55.50892+00
301	301	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	181300	2026-08-25 22:12:55.50892+00
302	302	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
303	303	RETRY_LINK	system	R05_TECH_RETRY	executed	493300	2026-08-25 22:12:55.50892+00
304	304	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	285100	2026-08-25 22:12:55.50892+00
305	305	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	465900	2026-08-25 22:12:55.50892+00
306	306	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
307	307	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	414900	2026-08-25 22:12:55.50892+00
308	308	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
309	309	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
310	310	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
311	311	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
312	312	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
313	313	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
314	314	RETRY_LINK	system	R05_TECH_RETRY	executed	93800	2026-08-25 22:12:55.50892+00
315	315	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
316	316	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	390900	2026-08-25 22:12:55.50892+00
317	317	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	80900	2026-08-25 22:12:55.50892+00
318	318	RETRY_LINK	system	R05_TECH_RETRY	executed	323800	2026-08-25 22:12:55.50892+00
319	319	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	82600	2026-08-25 22:12:55.50892+00
320	320	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
321	321	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
322	322	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
323	323	RETRY_LINK	system	R05_TECH_RETRY	executed	184600	2026-08-25 22:12:55.50892+00
324	324	RETRY_LINK	system	R05_TECH_RETRY	executed	260000	2026-08-25 22:12:55.50892+00
325	325	BLOCKED	system	R07_OFFLINE_QR_TRAP	blocked	0	2026-08-25 22:12:55.50892+00
326	326	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
327	327	RETRY_LINK	system	R05_TECH_RETRY	executed	339800	2026-08-25 22:12:55.50892+00
328	328	RETRY_LINK	system	R05_TECH_RETRY	executed	416800	2026-08-25 22:12:55.50892+00
329	329	RETRY_LINK	system	R05_TECH_RETRY	executed	167000	2026-08-25 22:12:55.50892+00
330	330	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
331	331	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	326100	2026-08-25 22:12:55.50892+00
332	332	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
333	333	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
334	334	RETRY_LINK	system	R05_TECH_RETRY	executed	382500	2026-08-25 22:12:55.50892+00
335	335	RETRY_LINK	system	R05_TECH_RETRY	executed	304800	2026-08-25 22:12:55.50892+00
336	336	RETRY_LINK	system	R05_TECH_RETRY	executed	330400	2026-08-25 22:12:55.50892+00
337	337	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	473200	2026-08-25 22:12:55.50892+00
338	338	RETRY_LINK	system	R05_TECH_RETRY	executed	128600	2026-08-25 22:12:55.50892+00
339	339	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
340	340	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	411500	2026-08-25 22:12:55.50892+00
341	341	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	421000	2026-08-25 22:12:55.50892+00
342	342	RETRY_LINK	system	R05_TECH_RETRY	executed	264400	2026-08-25 22:12:55.50892+00
343	343	RETRY_LINK	system	R05_TECH_RETRY	executed	284800	2026-08-25 22:12:55.50892+00
344	344	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
345	345	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
346	346	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
347	347	RETRY_LINK	system	R05_TECH_RETRY	executed	108100	2026-08-25 22:12:55.50892+00
348	348	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	465500	2026-08-25 22:12:55.50892+00
349	349	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
350	350	RETRY_LINK	system	R05_TECH_RETRY	executed	262900	2026-08-25 22:12:55.50892+00
351	351	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
352	352	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
353	353	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
354	354	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	151100	2026-08-25 22:12:55.50892+00
355	355	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
356	356	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
357	357	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
358	358	RETRY_LINK	system	R05_TECH_RETRY	executed	85200	2026-08-25 22:12:55.50892+00
359	359	RETRY_LINK	system	R05_TECH_RETRY	executed	387900	2026-08-25 22:12:55.50892+00
360	360	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	404900	2026-08-25 22:12:55.50892+00
361	361	RETRY_LINK	system	R05_TECH_RETRY	executed	69900	2026-08-25 22:12:55.50892+00
362	362	RETRY_LINK	system	R05_TECH_RETRY	executed	295900	2026-08-25 22:12:55.50892+00
363	363	RETRY_LINK	system	R05_TECH_RETRY	executed	437600	2026-08-25 22:12:55.50892+00
364	364	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
365	365	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
366	366	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
367	367	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	242900	2026-08-25 22:12:55.50892+00
368	368	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	168000	2026-08-25 22:12:55.50892+00
369	369	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
370	370	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	336400	2026-08-25 22:12:55.50892+00
371	371	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
372	372	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
373	373	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	265000	2026-08-25 22:12:55.50892+00
374	374	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	333100	2026-08-25 22:12:55.50892+00
375	375	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
376	376	RETRY_LINK	system	R05_TECH_RETRY	executed	251500	2026-08-25 22:12:55.50892+00
377	377	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	58800	2026-08-25 22:12:55.50892+00
378	378	RETRY_LINK	system	R05_TECH_RETRY	executed	174700	2026-08-25 22:12:55.50892+00
379	379	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
380	380	RETRY_LINK	system	R05_TECH_RETRY	executed	151900	2026-08-25 22:12:55.50892+00
381	381	RETRY_LINK	system	R05_TECH_RETRY	executed	41600	2026-08-25 22:12:55.50892+00
382	382	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
383	383	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	484000	2026-08-25 22:12:55.50892+00
384	384	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	458900	2026-08-25 22:12:55.50892+00
385	385	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
386	386	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	41300	2026-08-25 22:12:55.50892+00
387	387	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	111000	2026-08-25 22:12:55.50892+00
388	388	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
389	389	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
390	390	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
391	391	RETRY_LINK	system	R05_TECH_RETRY	executed	484000	2026-08-25 22:12:55.50892+00
392	392	RETRY_LINK	system	R05_TECH_RETRY	executed	242000	2026-08-25 22:12:55.50892+00
393	393	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
394	394	RETRY_LINK	system	R05_TECH_RETRY	executed	415800	2026-08-25 22:12:55.50892+00
395	395	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
396	396	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	317200	2026-08-25 22:12:55.50892+00
397	397	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	91200	2026-08-25 22:12:55.50892+00
398	398	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
399	399	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
400	400	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	54500	2026-08-25 22:12:55.50892+00
401	401	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	116600	2026-08-25 22:12:55.50892+00
402	402	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
403	403	RETRY_LINK	system	R05_TECH_RETRY	executed	239300	2026-08-25 22:12:55.50892+00
404	404	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	150400	2026-08-25 22:12:55.50892+00
405	405	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	366500	2026-08-25 22:12:55.50892+00
406	406	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
407	407	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	440400	2026-08-25 22:12:55.50892+00
408	408	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
409	409	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
410	410	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
411	411	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
412	412	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
413	413	RETRY_LINK	system	R05_TECH_RETRY	executed	377300	2026-08-25 22:12:55.50892+00
414	414	RETRY_LINK	system	R05_TECH_RETRY	executed	115700	2026-08-25 22:12:55.50892+00
415	415	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
416	416	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	248300	2026-08-25 22:12:55.50892+00
417	417	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	439000	2026-08-25 22:12:55.50892+00
418	418	RETRY_LINK	system	R05_TECH_RETRY	executed	59600	2026-08-25 22:12:55.50892+00
419	419	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	212300	2026-08-25 22:12:55.50892+00
420	420	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
421	421	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
422	422	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
423	423	RETRY_LINK	system	R05_TECH_RETRY	executed	429900	2026-08-25 22:12:55.50892+00
424	424	RETRY_LINK	system	R05_TECH_RETRY	executed	454400	2026-08-25 22:12:55.50892+00
425	425	BLOCKED	system	R07_OFFLINE_QR_TRAP	blocked	0	2026-08-25 22:12:55.50892+00
426	426	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
427	427	RETRY_LINK	system	R05_TECH_RETRY	executed	62300	2026-08-25 22:12:55.50892+00
428	428	RETRY_LINK	system	R05_TECH_RETRY	executed	386300	2026-08-25 22:12:55.50892+00
429	429	RETRY_LINK	system	R05_TECH_RETRY	executed	25200	2026-08-25 22:12:55.50892+00
430	430	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
431	431	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	235000	2026-08-25 22:12:55.50892+00
432	432	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
433	433	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
434	434	RETRY_LINK	system	R05_TECH_RETRY	executed	151600	2026-08-25 22:12:55.50892+00
435	435	RETRY_LINK	system	R05_TECH_RETRY	executed	109300	2026-08-25 22:12:55.50892+00
436	436	RETRY_LINK	system	R05_TECH_RETRY	executed	52500	2026-08-25 22:12:55.50892+00
437	437	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	43800	2026-08-25 22:12:55.50892+00
438	438	RETRY_LINK	system	R05_TECH_RETRY	executed	355800	2026-08-25 22:12:55.50892+00
439	439	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
440	440	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	52500	2026-08-25 22:12:55.50892+00
441	441	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	269400	2026-08-25 22:12:55.50892+00
442	442	RETRY_LINK	system	R05_TECH_RETRY	executed	317100	2026-08-25 22:12:55.50892+00
443	443	RETRY_LINK	system	R05_TECH_RETRY	executed	213600	2026-08-25 22:12:55.50892+00
444	444	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
445	445	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
446	446	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
447	447	RETRY_LINK	system	R05_TECH_RETRY	executed	210000	2026-08-25 22:12:55.50892+00
448	448	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	91100	2026-08-25 22:12:55.50892+00
449	449	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
451	451	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
452	452	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
453	453	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
454	454	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	142200	2026-08-25 22:12:55.50892+00
455	455	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
456	456	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
457	457	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
458	458	RETRY_LINK	system	R05_TECH_RETRY	executed	306300	2026-08-25 22:12:55.50892+00
459	459	RETRY_LINK	system	R05_TECH_RETRY	executed	157300	2026-08-25 22:12:55.50892+00
460	460	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	465500	2026-08-25 22:12:55.50892+00
461	461	RETRY_LINK	system	R05_TECH_RETRY	executed	114300	2026-08-25 22:12:55.50892+00
462	462	RETRY_LINK	system	R05_TECH_RETRY	executed	177200	2026-08-25 22:12:55.50892+00
463	463	RETRY_LINK	system	R05_TECH_RETRY	executed	495000	2026-08-25 22:12:55.50892+00
464	464	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
465	465	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
466	466	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
467	467	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	168200	2026-08-25 22:12:55.50892+00
468	468	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	216200	2026-08-25 22:12:55.50892+00
469	469	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
470	470	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	358300	2026-08-25 22:12:55.50892+00
471	471	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
472	472	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
473	473	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	36200	2026-08-25 22:12:55.50892+00
474	474	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	401300	2026-08-25 22:12:55.50892+00
475	475	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
476	476	RETRY_LINK	system	R05_TECH_RETRY	executed	452000	2026-08-25 22:12:55.50892+00
477	477	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	333000	2026-08-25 22:12:55.50892+00
478	478	RETRY_LINK	system	R05_TECH_RETRY	executed	275400	2026-08-25 22:12:55.50892+00
479	479	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
480	480	RETRY_LINK	system	R05_TECH_RETRY	executed	459000	2026-08-25 22:12:55.50892+00
481	481	RETRY_LINK	system	R05_TECH_RETRY	executed	60900	2026-08-25 22:12:55.50892+00
482	482	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
483	483	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	160200	2026-08-25 22:12:55.50892+00
484	484	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	495400	2026-08-25 22:12:55.50892+00
485	485	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
486	486	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	97600	2026-08-25 22:12:55.50892+00
487	487	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	372700	2026-08-25 22:12:55.50892+00
488	488	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
489	489	DEFERRED	system	Deferred to salary day. R04_LIQUIDITY_DEFER	scheduled	0	2026-08-25 22:12:55.50892+00
490	490	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
491	491	RETRY_LINK	system	R05_TECH_RETRY	executed	195800	2026-08-25 22:12:55.50892+00
492	492	RETRY_LINK	system	R05_TECH_RETRY	executed	286100	2026-08-25 22:12:55.50892+00
493	493	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
494	494	RETRY_LINK	system	R05_TECH_RETRY	executed	24200	2026-08-25 22:12:55.50892+00
495	495	BLOCKED	system	R03_STRUCTURAL_STOP	blocked	0	2026-08-25 22:12:55.50892+00
496	496	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	331000	2026-08-25 22:12:55.50892+00
497	497	RETRY_LINK	system	R06_DEFAULT_ALLOW	executed	325100	2026-08-25 22:12:55.50892+00
498	498	BLOCKED	system	R01_RBI_MANDATE	blocked	0	2026-08-25 22:12:55.50892+00
499	499	BLOCKED	system	R02_FEE_SHOCK	blocked	0	2026-08-25 22:12:55.50892+00
500	500	UPI_COLLECT	system	Mechanism Swap: OTP→UPI Collect. Link: https://rzp.io/l/revive-fallback | R06_DEFAULT_ALLOW	executed	154200	2026-08-25 22:12:55.50892+00
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 500, true);


--
-- Name: customer_payment_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_payment_history_id_seq', 640, true);


--
-- Name: diagnoses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.diagnoses_id_seq', 500, true);


--
-- Name: gate_decisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gate_decisions_id_seq', 500, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 63, true);


--
-- Name: merchant_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.merchant_config_id_seq', 5, true);


--
-- Name: payment_failures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_failures_id_seq', 500, true);


--
-- Name: promises_to_pay_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promises_to_pay_id_seq', 1, false);


--
-- Name: recovery_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recovery_actions_id_seq', 500, true);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: customer_payment_history customer_payment_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_payment_history
    ADD CONSTRAINT customer_payment_history_pkey PRIMARY KEY (id);


--
-- Name: diagnoses diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT diagnoses_pkey PRIMARY KEY (id);


--
-- Name: gate_decisions gate_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_decisions
    ADD CONSTRAINT gate_decisions_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: merchant_config merchant_config_merchant_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_config
    ADD CONSTRAINT merchant_config_merchant_id_key UNIQUE (merchant_id);


--
-- Name: merchant_config merchant_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_config
    ADD CONSTRAINT merchant_config_pkey PRIMARY KEY (id);


--
-- Name: payment_failures payment_failures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_failures
    ADD CONSTRAINT payment_failures_pkey PRIMARY KEY (id);


--
-- Name: promises_to_pay promises_to_pay_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promises_to_pay
    ADD CONSTRAINT promises_to_pay_pkey PRIMARY KEY (id);


--
-- Name: recovery_actions recovery_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_actions
    ADD CONSTRAINT recovery_actions_pkey PRIMARY KEY (id);


--
-- Name: ix_customer_payment_history_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_customer_payment_history_customer_id ON public.customer_payment_history USING btree (customer_id);


--
-- Name: ix_diagnoses_failure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_diagnoses_failure_id ON public.diagnoses USING btree (failure_id);


--
-- Name: ix_gate_decisions_failure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_gate_decisions_failure_id ON public.gate_decisions USING btree (failure_id);


--
-- Name: ix_jobs_failure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_jobs_failure_id ON public.jobs USING btree (failure_id);


--
-- Name: ix_jobs_run_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_jobs_run_at ON public.jobs USING btree (run_at);


--
-- Name: ix_payment_failures_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payment_failures_customer_id ON public.payment_failures USING btree (customer_id);


--
-- Name: ix_payment_failures_external_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_payment_failures_external_payment_id ON public.payment_failures USING btree (external_payment_id);


--
-- Name: ix_payment_failures_merchant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payment_failures_merchant_id ON public.payment_failures USING btree (merchant_id);


--
-- Name: ix_promises_to_pay_failure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_promises_to_pay_failure_id ON public.promises_to_pay USING btree (failure_id);


--
-- Name: ix_recovery_actions_failure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_recovery_actions_failure_id ON public.recovery_actions USING btree (failure_id);


--
-- Name: diagnoses diagnoses_failure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT diagnoses_failure_id_fkey FOREIGN KEY (failure_id) REFERENCES public.payment_failures(id);


--
-- Name: gate_decisions gate_decisions_failure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_decisions
    ADD CONSTRAINT gate_decisions_failure_id_fkey FOREIGN KEY (failure_id) REFERENCES public.payment_failures(id);


--
-- Name: jobs jobs_failure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_failure_id_fkey FOREIGN KEY (failure_id) REFERENCES public.payment_failures(id);


--
-- Name: promises_to_pay promises_to_pay_failure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promises_to_pay
    ADD CONSTRAINT promises_to_pay_failure_id_fkey FOREIGN KEY (failure_id) REFERENCES public.payment_failures(id);


--
-- Name: recovery_actions recovery_actions_failure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_actions
    ADD CONSTRAINT recovery_actions_failure_id_fkey FOREIGN KEY (failure_id) REFERENCES public.payment_failures(id);


--
-- PostgreSQL database dump complete
--

\unrestrict A9Uzfmw2wQNfl9M127kla8Oi6lVequnUoNhqyiSh2cnXpHC8rBPkFcOSZggYpF2

