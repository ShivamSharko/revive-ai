--
-- PostgreSQL database dump
--

\restrict 9DIKROh3vgdm4y3xHEGWZxcJ1WUG4m0H2MtcJYbjIdzXKrFXmTQo6ZbhF5T7BuJ

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
    rule_id character varying(16),
    verdict character varying(8),
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
-- Name: recovery_actions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_actions ALTER COLUMN id SET DEFAULT nextval('public.recovery_actions_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, entity_type, entity_id, actor, action, reasoning, metadata_json, created_at) FROM stdin;
1	failure	501	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 04:52:07.977617+00
7002	failure	501	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:57:20.308257+00
6502	failure	16	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6503	failure	17	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6504	failure	19	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6505	failure	116	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6506	failure	117	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6507	failure	119	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6508	failure	125	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6509	failure	131	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6510	failure	137	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6511	failure	187	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6512	failure	196	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6513	failure	204	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6514	failure	178	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6515	failure	210	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6516	failure	296	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6517	failure	304	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6518	failure	316	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6519	failure	317	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6520	failure	319	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6521	failure	396	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6522	failure	404	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6523	failure	416	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6524	failure	417	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6525	failure	419	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6526	failure	290	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6527	failure	302	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6528	failure	310	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6529	failure	312	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6530	failure	313	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6531	failure	376	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6532	failure	73	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6533	failure	378	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6534	failure	390	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6535	failure	410	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6536	failure	413	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6537	failure	490	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6538	failure	10	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6539	failure	12	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6540	failure	13	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6541	failure	86	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6542	failure	90	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6543	failure	102	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6544	failure	185	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6545	failure	212	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6546	failure	213	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6547	failure	469	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6548	failure	37	system	BLOCK:OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-22 20:53:04.852175+00
6549	failure	121	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6550	failure	216	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6551	failure	217	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6552	failure	219	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6553	failure	225	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6554	failure	231	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6555	failure	278	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6556	failure	286	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6557	failure	287	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6558	failure	425	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6559	failure	496	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6560	failure	140	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6561	failure	44	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6562	failure	45	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6563	failure	158	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6564	failure	240	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6565	failure	283	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6566	failure	284	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6567	failure	440	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6568	failure	4	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6569	failure	1	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6570	failure	3	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6571	failure	5	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6572	failure	6	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6573	failure	7	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6574	failure	8	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6575	failure	9	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6576	failure	11	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6577	failure	14	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6578	failure	15	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6579	failure	18	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6580	failure	20	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6581	failure	21	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6582	failure	22	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6583	failure	23	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6584	failure	24	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6585	failure	26	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6586	failure	27	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6587	failure	28	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6588	failure	29	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6589	failure	30	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6590	failure	2	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6591	failure	25	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6592	failure	32	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6593	failure	33	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6594	failure	34	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6595	failure	35	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6596	failure	36	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6597	failure	38	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6598	failure	40	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6599	failure	41	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6600	failure	42	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6601	failure	43	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6602	failure	46	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6603	failure	47	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6604	failure	48	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6605	failure	49	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6606	failure	50	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6607	failure	51	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6608	failure	52	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6609	failure	53	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6610	failure	54	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6611	failure	55	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6612	failure	56	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6613	failure	57	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6614	failure	58	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6615	failure	59	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6616	failure	60	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6617	failure	61	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6618	failure	39	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6619	failure	31	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6620	failure	62	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6621	failure	63	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6622	failure	64	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6623	failure	65	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6624	failure	66	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 15.	\N	2026-08-22 20:53:04.852175+00
6625	failure	67	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6626	failure	68	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6627	failure	69	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6628	failure	70	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6629	failure	71	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6630	failure	72	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6631	failure	74	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6632	failure	75	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6633	failure	76	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6634	failure	77	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6635	failure	79	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6636	failure	80	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6637	failure	81	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6638	failure	82	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6639	failure	83	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6640	failure	84	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6641	failure	85	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6642	failure	88	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 15.	\N	2026-08-22 20:53:04.852175+00
6643	failure	89	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6644	failure	91	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6645	failure	92	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6646	failure	93	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6647	failure	87	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6648	failure	78	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6649	failure	94	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6650	failure	95	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6651	failure	97	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6652	failure	98	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6653	failure	99	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6654	failure	100	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6655	failure	101	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6656	failure	103	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6657	failure	104	system	BLOCK:OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-22 20:53:04.852175+00
6658	failure	105	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6659	failure	106	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6660	failure	107	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6661	failure	108	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6662	failure	111	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6663	failure	114	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6664	failure	115	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6665	failure	118	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6666	failure	120	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6667	failure	122	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6668	failure	123	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6669	failure	124	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6670	failure	110	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6671	failure	113	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6672	failure	109	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6673	failure	112	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6674	failure	96	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6675	failure	126	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6676	failure	127	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6677	failure	128	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6678	failure	129	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6679	failure	130	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6680	failure	132	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6681	failure	133	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6682	failure	134	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6683	failure	135	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6684	failure	136	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6685	failure	138	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6686	failure	139	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6687	failure	141	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6688	failure	142	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6689	failure	143	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6690	failure	144	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6691	failure	145	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6692	failure	146	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6693	failure	147	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6694	failure	148	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6695	failure	149	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6696	failure	150	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6697	failure	151	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6698	failure	152	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6699	failure	153	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6700	failure	154	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6701	failure	155	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 15.	\N	2026-08-22 20:53:04.852175+00
6702	failure	156	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6703	failure	157	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6704	failure	159	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6705	failure	160	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6706	failure	161	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6707	failure	162	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6708	failure	163	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6709	failure	164	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6710	failure	165	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6711	failure	166	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6712	failure	167	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6713	failure	168	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6714	failure	169	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6715	failure	170	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6716	failure	171	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6717	failure	172	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6718	failure	173	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6719	failure	174	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6720	failure	175	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6721	failure	176	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6722	failure	177	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6723	failure	179	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6724	failure	180	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6725	failure	181	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6726	failure	182	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6727	failure	183	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6728	failure	184	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6729	failure	186	system	BLOCK:OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-22 20:53:04.852175+00
6730	failure	188	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6731	failure	189	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 15.	\N	2026-08-22 20:53:04.852175+00
6732	failure	190	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6733	failure	191	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6734	failure	192	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6735	failure	193	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6736	failure	194	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6737	failure	195	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6738	failure	197	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6739	failure	198	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6740	failure	199	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6741	failure	200	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6742	failure	201	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6743	failure	203	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6744	failure	205	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6745	failure	206	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6746	failure	207	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6747	failure	208	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6748	failure	209	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6749	failure	211	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 15.	\N	2026-08-22 20:53:04.852175+00
6750	failure	214	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6751	failure	215	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6752	failure	218	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6753	failure	202	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6754	failure	220	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6755	failure	221	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6756	failure	222	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6757	failure	223	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6758	failure	224	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6759	failure	226	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6760	failure	227	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6761	failure	228	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6762	failure	229	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6763	failure	230	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6764	failure	232	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6765	failure	233	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6766	failure	234	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6767	failure	235	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6768	failure	236	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6769	failure	238	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6770	failure	239	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6771	failure	241	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6772	failure	242	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6773	failure	243	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6774	failure	244	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6775	failure	245	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6776	failure	246	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6777	failure	247	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6778	failure	248	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6779	failure	249	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6780	failure	250	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6781	failure	251	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6782	failure	237	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6783	failure	252	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6784	failure	253	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6785	failure	254	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6786	failure	255	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6787	failure	256	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6788	failure	257	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6789	failure	258	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6790	failure	259	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6791	failure	260	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6792	failure	261	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6793	failure	262	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6794	failure	263	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6795	failure	264	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6796	failure	265	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6797	failure	266	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6798	failure	267	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6799	failure	268	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6800	failure	270	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6801	failure	271	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6802	failure	272	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6803	failure	273	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6804	failure	274	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6805	failure	275	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6806	failure	276	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6807	failure	277	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6808	failure	279	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6809	failure	280	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6810	failure	281	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6811	failure	282	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6812	failure	269	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6813	failure	285	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6814	failure	288	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 15.	\N	2026-08-22 20:53:04.852175+00
6815	failure	289	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6816	failure	291	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6817	failure	292	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6818	failure	293	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6819	failure	294	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6820	failure	295	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6821	failure	297	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6822	failure	298	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6823	failure	299	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6824	failure	300	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6825	failure	301	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6826	failure	303	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6827	failure	305	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6828	failure	306	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6829	failure	307	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6830	failure	308	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6831	failure	309	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6832	failure	311	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6833	failure	314	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6834	failure	315	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6835	failure	318	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6836	failure	320	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6837	failure	321	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6838	failure	322	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6839	failure	323	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6840	failure	324	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6841	failure	325	system	BLOCK:OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-22 20:53:04.852175+00
6842	failure	326	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6843	failure	327	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6844	failure	328	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6845	failure	329	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6846	failure	330	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6847	failure	331	system	BLOCK:OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-22 20:53:04.852175+00
6848	failure	332	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6849	failure	333	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6850	failure	334	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6851	failure	335	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6852	failure	336	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6853	failure	338	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6854	failure	339	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6855	failure	340	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6856	failure	341	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6857	failure	342	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6858	failure	343	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6859	failure	344	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6860	failure	345	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6861	failure	346	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6862	failure	337	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6863	failure	347	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6864	failure	348	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6865	failure	349	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6866	failure	350	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6867	failure	351	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6868	failure	352	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6869	failure	353	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6870	failure	354	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6871	failure	355	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6872	failure	356	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6873	failure	357	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6874	failure	358	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6875	failure	359	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6876	failure	360	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6877	failure	361	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6878	failure	362	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6879	failure	363	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6880	failure	364	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6881	failure	365	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6882	failure	366	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6883	failure	367	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6884	failure	368	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6885	failure	369	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6886	failure	370	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6887	failure	371	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6888	failure	372	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6889	failure	373	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6890	failure	374	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6891	failure	375	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6892	failure	377	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6893	failure	379	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6894	failure	380	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6895	failure	381	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6896	failure	382	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6897	failure	383	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6898	failure	384	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6899	failure	388	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6900	failure	389	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6901	failure	391	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6902	failure	392	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6903	failure	393	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6904	failure	394	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6905	failure	395	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6906	failure	397	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6907	failure	398	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6908	failure	399	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6909	failure	400	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6910	failure	401	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6911	failure	403	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6912	failure	405	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6913	failure	406	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6914	failure	407	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6915	failure	408	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6916	failure	385	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6917	failure	386	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6918	failure	387	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6919	failure	402	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6920	failure	409	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6921	failure	411	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6922	failure	412	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6923	failure	414	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6924	failure	415	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6925	failure	418	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6926	failure	420	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6927	failure	421	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6928	failure	422	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6929	failure	423	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6930	failure	424	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6931	failure	426	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6932	failure	427	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6933	failure	428	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6934	failure	429	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6935	failure	430	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6936	failure	432	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6937	failure	433	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6938	failure	434	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6939	failure	435	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6940	failure	436	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6941	failure	437	system	BLOCK:OFFLINE_QR_TRAP	Customer left store. Silent retry blocked to prevent double-charge.	\N	2026-08-22 20:53:04.852175+00
6942	failure	438	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6943	failure	439	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6944	failure	431	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6945	failure	441	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6946	failure	442	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6947	failure	443	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6948	failure	444	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6949	failure	445	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6950	failure	446	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6951	failure	447	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6952	failure	448	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6953	failure	449	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 5.	\N	2026-08-22 20:53:04.852175+00
6954	failure	450	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6955	failure	451	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6956	failure	452	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6957	failure	453	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6958	failure	454	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6959	failure	455	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6960	failure	456	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6961	failure	457	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6962	failure	458	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6963	failure	459	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6964	failure	460	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6965	failure	461	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6966	failure	462	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6967	failure	463	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6968	failure	464	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6969	failure	465	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6970	failure	466	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6971	failure	467	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6972	failure	468	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6973	failure	470	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6974	failure	471	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6975	failure	472	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6976	failure	473	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6977	failure	474	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6978	failure	475	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6979	failure	476	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6980	failure	477	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6981	failure	478	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6982	failure	479	system	BLOCK:FEE_SHOCK	Hidden fees caused abandonment. Do not retry.	\N	2026-08-22 20:53:04.852175+00
6983	failure	480	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6984	failure	481	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6985	failure	482	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 20.	\N	2026-08-22 20:53:04.852175+00
6986	failure	483	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6987	failure	484	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6988	failure	485	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 15.	\N	2026-08-22 20:53:04.852175+00
6989	failure	488	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6990	failure	489	system	DEFER:LIQUIDITY_DEFER	Insufficient funds. Defer to salary day 1.	\N	2026-08-22 20:53:04.852175+00
6991	failure	491	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6992	failure	492	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6993	failure	493	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6994	failure	494	system	ALLOW:TECH_RETRY	Transient technical failure. Safe to retry.	\N	2026-08-22 20:53:04.852175+00
6995	failure	495	system	BLOCK:STRUCTURAL_STOP	Repeated failures. Spamming will cause churn.	\N	2026-08-22 20:53:04.852175+00
6996	failure	497	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6997	failure	498	system	BLOCK:RBI_MANDATE	Pre-debit notification < 24h. RBI compliance block.	\N	2026-08-22 20:53:04.852175+00
6998	failure	500	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
6999	failure	486	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
7000	failure	487	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
7001	failure	499	system	ALLOW:DEFAULT_ALLOW	No blocking rules triggered.	\N	2026-08-22 20:53:04.852175+00
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
3502	9	intent	merchant	0.9	fee shock abandonment	groq	2026-08-22 16:50:40.649933+00
3002	16	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3003	17	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3004	19	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3005	116	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3503	11	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 16:50:40.649933+00
3504	14	technical	infra	0.9	gateway 5xx error	groq	2026-08-22 16:50:40.649933+00
3505	15	lifecycle	merchant	0.9	pre‑debit notification <24h	groq	2026-08-22 16:50:40.649933+00
3506	18	technical	infra	0.9	gateway 5xx error	groq	2026-08-22 16:50:40.649933+00
3507	20	lifecycle	merchant	0.9	pre‑debit notification <24h	groq	2026-08-22 16:50:40.649933+00
3508	21	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 16:50:40.649933+00
3509	22	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-22 16:50:40.649933+00
3510	23	technical	infra	0.9	UPI bank timeout	groq	2026-08-22 16:50:40.649933+00
3511	24	technical	infra	0.9	UPI bank timeout	groq	2026-08-22 16:50:40.649933+00
3512	26	lifecycle	merchant	0.95	Pre-debit notification sent less than 24 hours prior to recurring debit violates notification timing mandates.	gemini	2026-08-22 16:50:40.649933+00
3513	27	technical	infra	0.95	PSP timeout due to degraded bank servers indicates an infrastructure failure.	gemini	2026-08-22 16:50:40.649933+00
3514	28	technical	infra	0.95	Issuer gateway 502 HTTP error represents a bank/gateway technical infrastructure issue.	gemini	2026-08-22 16:50:40.649933+00
3515	29	technical	infra	0.95	UPI timeout at PSP caused by degraded bank servers is a technical infrastructure issue.	gemini	2026-08-22 16:50:40.649933+00
3516	30	intent	merchant	0.9	Session abandonment immediately after fee disclosure reflects customer drop-off triggered by merchant fee shock.	gemini	2026-08-22 16:50:40.649933+00
3517	2	technical	merchant	0.95	Merchant checkout misconfiguration rejecting valid payment payloads is a merchant-side technical error.	gemini	2026-08-22 16:50:40.649933+00
3518	4	intent	customer_temp	0.85	Customer leaving before in-store QR payment completion represents temporary intent drop-off.	gemini	2026-08-22 16:50:40.649933+00
3519	25	intent	customer_temp	0.85	Customer abandoning in-store QR scan process before completion signifies temporary intent loss.	gemini	2026-08-22 16:50:40.649933+00
3520	31	intent	customer_temp	0.85	Timeout resulting from customer walking away during QR payment indicates temporary customer intent drop-off.	gemini	2026-08-22 16:50:40.649933+00
3521	32	lifecycle	merchant	0.95	Pre-debit notification breach (<24h) is a lifecycle failure caused by non-compliant merchant notification timing.	gemini	2026-08-22 16:50:40.649933+00
3522	44	affordability	merchant	0.95	Customer abandoned session due to fee shock upon fee reveal; merchant-controlled pricing presentation.	gemini	2026-08-22 16:50:40.649933+00
3523	45	affordability	merchant	0.95	Customer abandoned session due to fee shock upon fee reveal; merchant-controlled pricing presentation.	gemini	2026-08-22 16:50:40.649933+00
3524	46	lifecycle	merchant	0.98	Pre-debit notification sent less than 24 hours prior to recurring debit, violating regulatory notification lifecycle rules.	gemini	2026-08-22 16:50:40.649933+00
3525	47	technical	infra	0.98	UPI request timed out due to degraded bank/PSP servers.	gemini	2026-08-22 16:50:40.649933+00
3526	48	lifecycle	customer_temp	0.95	Card stored on file has expired; temporary lifecycle issue requiring customer update.	gemini	2026-08-22 16:50:40.649933+00
3527	49	affordability	customer_temp	0.95	Single transaction decline due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3528	50	technical	infra	0.98	UPI request timed out due to degraded bank/PSP servers.	gemini	2026-08-22 16:50:40.649933+00
3529	51	affordability	customer_temp	0.95	Single transaction decline due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3530	52	lifecycle	merchant	0.98	Pre-debit notification sent less than 24 hours prior to recurring debit, violating regulatory notification lifecycle rules.	gemini	2026-08-22 16:50:40.649933+00
3531	53	affordability	customer_structural	0.98	Repeated declines (4th consecutive cycle) for insufficient balance indicate a structural affordability issue.	gemini	2026-08-22 16:50:40.649933+00
3532	54	intent	customer_temp	0.95	User abandoned payment during OTP step without technical failure signals.	gemini	2026-08-22 16:50:40.649933+00
3533	55	affordability	customer_temp	0.9	Transaction failed due to single instance of insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3534	56	lifecycle	merchant	0.95	Pre-debit notification sent less than 24 hours prior to debit breach regulatory rules.	gemini	2026-08-22 16:50:40.649933+00
3535	57	lifecycle	merchant	0.95	Pre-debit notification sent less than 24 hours prior to debit breach regulatory rules.	gemini	2026-08-22 16:50:40.649933+00
3536	58	technical	infra	0.95	Gateway 502 error during authorization indicates issuer infrastructure issue.	gemini	2026-08-22 16:50:40.649933+00
3537	59	technical	infra	0.95	Timeout at PSP due to degraded bank servers represents infrastructure issues.	gemini	2026-08-22 16:50:40.649933+00
3538	60	intent	customer_temp	0.95	User abandoned payment during OTP step without technical failure signals.	gemini	2026-08-22 16:50:40.649933+00
3539	61	technical	infra	0.95	Timeout at PSP due to degraded bank servers represents infrastructure issues.	gemini	2026-08-22 16:50:40.649933+00
3540	62	technical	infra	0.95	Timeout at PSP due to degraded bank servers represents infrastructure issues.	gemini	2026-08-22 16:50:40.649933+00
3541	63	technical	infra	0.95	Timeout at PSP due to degraded bank servers represents infrastructure issues.	gemini	2026-08-22 16:50:40.649933+00
3542	64	lifecycle	merchant	0.95	Pre-debit notification sent less than 24 hours before debit violates regulatory rules, caused by merchant.	gemini	2026-08-22 16:50:40.649933+00
3543	65	intent	merchant	0.9	User abandoned session at fee reveal due to merchant fee shock.	gemini	2026-08-22 16:50:40.649933+00
3544	66	affordability	customer_temp	0.9	Single decline for insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3545	67	intent	customer_temp	0.85	User dropped at OTP step with no other failure signals.	gemini	2026-08-22 16:50:40.649933+00
3546	68	intent	customer_temp	0.85	User dropped at OTP step with no other failure signals.	gemini	2026-08-22 16:50:40.649933+00
3547	69	affordability	customer_temp	0.9	Single decline for insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3548	70	intent	customer_temp	0.85	User dropped at OTP step with no other failure signals.	gemini	2026-08-22 16:50:40.649933+00
3549	71	affordability	customer_structural	0.95	Repeated insufficient balance over multiple billing cycles.	gemini	2026-08-22 16:50:40.649933+00
3550	72	affordability	customer_structural	0.95	Repeated insufficient balance over multiple billing cycles.	gemini	2026-08-22 16:50:40.649933+00
3006	117	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3007	119	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3008	125	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3009	131	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3010	137	intent	customer_temp	0.9	QR scan timed out, customer left before completion	groq	2026-08-22 16:05:42.239522+00
3011	178	technical	merchant	0.9	Merchant checkout misconfiguration rejected payment payload	groq	2026-08-22 16:05:42.239522+00
3012	187	intent	customer_temp	0.9	QR scan timed out and customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3013	196	intent	customer_temp	0.9	QR scan timed out and customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3014	204	intent	customer_temp	0.9	QR scan timed out and customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3015	210	technical	merchant	0.95	Merchant checkout misconfiguration rejected the payment payload	groq	2026-08-22 16:05:42.239522+00
3016	296	intent	customer_temp	0.9	QR scan timed out and customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3017	304	intent	customer_temp	0.9	QR scan timed out and customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3018	316	intent	customer_temp	0.9	QR scan timed out and customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3019	317	intent	customer_temp	0.9	QR scan timed out and customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3020	319	intent	customer_temp	0.9	QR scan timed out and customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3021	376	technical	merchant	0.95	Merchant checkout misconfiguration rejected the payment payload	groq	2026-08-22 16:05:42.239522+00
3022	378	technical	merchant	0.9	checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3023	390	technical	merchant	0.9	checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3024	396	intent	customer_temp	0.9	qr scan timeout, customer left	groq	2026-08-22 16:05:42.239522+00
3025	404	intent	customer_temp	0.9	qr scan timeout, customer left	groq	2026-08-22 16:05:42.239522+00
3026	410	technical	merchant	0.9	checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3027	413	technical	merchant	0.9	checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3028	416	intent	customer_temp	0.9	qr scan timeout, customer left	groq	2026-08-22 16:05:42.239522+00
3029	417	intent	customer_temp	0.9	qr scan timeout, customer left	groq	2026-08-22 16:05:42.239522+00
3030	419	intent	customer_temp	0.9	qr scan timeout, customer left	groq	2026-08-22 16:05:42.239522+00
3031	490	technical	merchant	0.9	checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3032	290	technical	merchant	0.9	merchant checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3033	302	technical	merchant	0.9	merchant checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3034	310	technical	merchant	0.9	merchant checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3035	312	affordability	customer_temp	0.9	single insufficient balance	groq	2026-08-22 16:05:42.239522+00
3036	313	technical	merchant	0.9	merchant checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3037	73	lifecycle	customer_temp	0.9	card expired	groq	2026-08-22 16:05:42.239522+00
3038	10	technical	merchant	0.9	merchant checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3039	12	affordability	customer_temp	0.9	single insufficient balance	groq	2026-08-22 16:05:42.239522+00
3040	13	technical	merchant	0.9	merchant checkout misconfiguration	groq	2026-08-22 16:05:42.239522+00
3041	37	technical	infra	0.9	offline QR timeout	groq	2026-08-22 16:05:42.239522+00
3042	86	intent	customer_temp	0.9	QR scan timed out, customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3043	90	technical	merchant	0.9	Merchant checkout misconfiguration rejected payload	groq	2026-08-22 16:05:42.239522+00
3044	102	technical	merchant	0.9	Merchant checkout misconfiguration rejected payload	groq	2026-08-22 16:05:42.239522+00
3045	121	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 16:05:42.239522+00
3046	185	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 16:05:42.239522+00
3047	212	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 16:05:42.239522+00
3048	213	technical	merchant	0.9	Merchant checkout misconfiguration rejected payload	groq	2026-08-22 16:05:42.239522+00
3049	216	intent	customer_temp	0.9	QR scan timed out, customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3050	217	intent	customer_temp	0.9	QR scan timed out, customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3051	219	intent	customer_temp	0.9	QR scan timed out, customer left before completing payment	groq	2026-08-22 16:05:42.239522+00
3052	225	intent	customer_temp	0.9	offline QR timed out, user left	groq	2026-08-22 16:05:42.239522+00
3053	231	intent	customer_temp	0.9	offline QR timed out, user left	groq	2026-08-22 16:05:42.239522+00
3054	278	intent	merchant	0.9	checkout misconfiguration rejected payload	groq	2026-08-22 16:05:42.239522+00
3055	286	intent	customer_temp	0.9	offline QR timed out, user left	groq	2026-08-22 16:05:42.239522+00
3056	287	intent	customer_temp	0.9	offline QR timed out, user left	groq	2026-08-22 16:05:42.239522+00
3057	425	intent	customer_temp	0.9	offline QR timed out, user left	groq	2026-08-22 16:05:42.239522+00
3058	469	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-22 16:05:42.239522+00
3059	496	intent	customer_temp	0.9	offline QR timed out, user left	groq	2026-08-22 16:05:42.239522+00
3060	140	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 16:05:42.239522+00
3061	158	technical	infra	0.9	gateway returned 5xx error	groq	2026-08-22 16:05:42.239522+00
3062	240	lifecycle	customer_temp	0.95	Card on file expired, requiring customer action to update card details.	gemini	2026-08-22 16:05:42.239522+00
3063	283	lifecycle	customer_temp	0.95	Card on file expired, requiring customer action to update card details.	gemini	2026-08-22 16:05:42.239522+00
3064	284	lifecycle	customer_temp	0.95	Card on file expired, requiring customer action to update card details.	gemini	2026-08-22 16:05:42.239522+00
3065	440	lifecycle	customer_temp	0.95	Card on file expired, requiring customer action to update card details.	gemini	2026-08-22 16:05:42.239522+00
3066	1	lifecycle	customer_temp	0.95	Card on file expired, requiring customer action to update card details.	gemini	2026-08-22 16:05:42.239522+00
3067	3	technical	infra	0.95	UPI request timed out at bank/PSP server.	gemini	2026-08-22 16:05:42.239522+00
3872	97	lifecycle	customer_temp	0.95	card expired	groq	2026-08-22 18:51:28.194151+00
3068	5	lifecycle	customer_temp	0.95	Card on file expired, requiring customer action to update card details.	gemini	2026-08-22 16:05:42.239522+00
3069	6	intent	merchant	0.9	User abandoned checkout upon fee reveal (fee shock), attributed to merchant pricing/fee disclosure.	gemini	2026-08-22 16:05:42.239522+00
3070	7	intent	customer_temp	0.95	User dropped off at OTP entry with no additional failure signals.	gemini	2026-08-22 16:05:42.239522+00
3071	8	intent	merchant	0.9	User abandoned checkout upon fee reveal (fee shock), attributed to merchant pricing/fee disclosure.	gemini	2026-08-22 16:05:42.239522+00
3873	98	lifecycle	merchant	0.95	pre‑debit notification sent <24h before debit	groq	2026-08-22 18:51:28.194151+00
3874	99	intent	merchant	0.9	user dropped at fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
3875	100	intent	customer_temp	0.95	user dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3876	101	lifecycle	customer_temp	0.95	card expired	groq	2026-08-22 18:51:28.194151+00
3877	103	technical	infra	0.95	UPI request timed out at PSP/bank	groq	2026-08-22 18:51:28.194151+00
3878	104	technical	infra	0.95	QR scan timed out in‑store	groq	2026-08-22 18:51:28.194151+00
3879	105	lifecycle	customer_temp	0.95	card expired	groq	2026-08-22 18:51:28.194151+00
3880	106	intent	merchant	0.9	user dropped at fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
3881	107	intent	customer_temp	0.95	user dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3882	108	intent	merchant	0.95	User dropped session at fee reveal (fee shock) – merchant config issue	groq	2026-08-22 18:51:28.194151+00
3883	111	affordability	customer_temp	0.96	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 18:51:28.194151+00
3884	114	technical	infra	0.97	Issuer gateway returned 502 – bank/PSP error	groq	2026-08-22 18:51:28.194151+00
3885	115	lifecycle	merchant	0.94	Pre‑debit notification sent <24 h before debit – lifecycle breach caused by merchant schedule	groq	2026-08-22 18:51:28.194151+00
3886	118	technical	infra	0.97	Issuer gateway returned 502 – bank/PSP error	groq	2026-08-22 18:51:28.194151+00
3887	120	lifecycle	merchant	0.94	Pre‑debit notification sent <24 h before debit – lifecycle breach caused by merchant schedule	groq	2026-08-22 18:51:28.194151+00
3888	122	affordability	customer_structural	0.96	Repeated insufficient‑balance declines across cycles indicates structural affordability issue	groq	2026-08-22 18:51:28.194151+00
3889	123	technical	infra	0.97	UPI request timed out at PSP – bank server timeout	groq	2026-08-22 18:51:28.194151+00
3890	124	technical	infra	0.97	UPI request timed out at PSP – bank server timeout	groq	2026-08-22 18:51:28.194151+00
3891	109	intent	merchant	0.95	User dropped session at fee reveal (fee shock) – merchant config issue	groq	2026-08-22 18:51:28.194151+00
3892	134	technical	infra	0.95	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 18:51:28.194151+00
3092	33	affordability	customer_temp	0.9	insufficient balance (single occurrence)	groq	2026-08-22 16:05:42.239522+00
3093	34	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 16:05:42.239522+00
3094	35	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 16:05:42.239522+00
3095	36	technical	infra	0.9	gateway 5xx error	groq	2026-08-22 16:05:42.239522+00
3096	38	technical	infra	0.9	gateway 5xx error	groq	2026-08-22 16:05:42.239522+00
3097	39	affordability	customer_structural	0.9	insufficient balance (repeated)	groq	2026-08-22 16:05:42.239522+00
3098	40	lifecycle	customer_temp	0.9	card expired	groq	2026-08-22 16:05:42.239522+00
3099	41	intent	customer_temp	0.9	user dropped at OTP	groq	2026-08-22 16:05:42.239522+00
3100	42	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 16:05:42.239522+00
3101	43	technical	infra	0.9	gateway 5xx error	groq	2026-08-22 16:05:42.239522+00
3893	135	technical	infra	0.95	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 18:51:28.194151+00
3894	136	technical	infra	0.95	Issuer gateway returned 502 during authorization	groq	2026-08-22 18:51:28.194151+00
3895	138	technical	infra	0.95	Issuer gateway returned 502 during authorization	groq	2026-08-22 18:51:28.194151+00
3896	139	affordability	customer_temp	0.9	Bank declined: insufficient balance	groq	2026-08-22 18:51:28.194151+00
3897	141	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3898	142	technical	infra	0.95	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 18:51:28.194151+00
3899	143	technical	infra	0.95	Issuer gateway returned 502 during authorization	groq	2026-08-22 18:51:28.194151+00
3900	144	intent	merchant	0.9	User abandoned at fee reveal (fee shock) before payment attempt	groq	2026-08-22 18:51:28.194151+00
3901	145	intent	merchant	0.9	User abandoned at fee reveal (fee shock) before payment attempt	groq	2026-08-22 18:51:28.194151+00
3902	156	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 18:51:28.194151+00
3903	157	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 18:51:28.194151+00
3904	159	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 18:51:28.194151+00
3905	160	intent	customer_temp	0.9	dropped at OTP	groq	2026-08-22 18:51:28.194151+00
3906	161	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 18:51:28.194151+00
3907	162	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 18:51:28.194151+00
3908	163	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 18:51:28.194151+00
3909	164	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 18:51:28.194151+00
3910	165	intent	merchant	0.9	dropped at fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
3911	166	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 18:51:28.194151+00
3912	167	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3913	168	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3914	169	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-22 18:51:28.194151+00
3915	170	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3916	171	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-22 18:51:28.194151+00
3917	172	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-22 18:51:28.194151+00
3918	173	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 18:51:28.194151+00
3919	174	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3920	175	intent	merchant	0.9	user abandoned after fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
3921	176	technical	merchant	0.9	merchant checkout configuration error	groq	2026-08-22 18:51:28.194151+00
3922	177	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3923	179	intent	merchant	0.9	session dropped at fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
3924	180	technical	infra	0.9	UPI request timed out at PSP (bank server degraded)	groq	2026-08-22 18:51:28.194151+00
3925	181	technical	infra	0.9	UPI request timed out at PSP (bank server degraded)	groq	2026-08-22 18:51:28.194151+00
3926	182	affordability	customer_temp	0.9	bank declined due to insufficient balance	groq	2026-08-22 18:51:28.194151+00
3927	183	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 18:51:28.194151+00
3928	184	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 18:51:28.194151+00
3929	186	technical	infra	0.9	QR scan timed out in‑store, customer left	groq	2026-08-22 18:51:28.194151+00
3930	188	affordability	customer_temp	0.9	bank declined due to insufficient balance	groq	2026-08-22 18:51:28.194151+00
3931	189	affordability	customer_temp	0.9	bank declined due to insufficient balance	groq	2026-08-22 18:51:28.194151+00
3932	190	technical	merchant	0.95	Merchant checkout misconfiguration rejected payment payload.	gemini	2026-08-22 18:51:28.194151+00
3933	191	technical	infra	0.95	PSP/bank timeout degraded server response.	gemini	2026-08-22 18:51:28.194151+00
3934	192	technical	infra	0.95	Issuer gateway returned 502 5xx error.	gemini	2026-08-22 18:51:28.194151+00
3935	193	affordability	customer_structural	0.95	Repeated insufficient balance over 4 consecutive cycles.	gemini	2026-08-22 18:51:28.194151+00
3936	194	technical	infra	0.95	UPI request timed out at PSP.	gemini	2026-08-22 18:51:28.194151+00
3937	195	affordability	customer_structural	0.95	Repeated insufficient balance over multiple recurring cycles.	gemini	2026-08-22 18:51:28.194151+00
3938	197	lifecycle	customer_temp	0.95	Card on file has expired.	gemini	2026-08-22 18:51:28.194151+00
3939	198	lifecycle	merchant	0.95	Pre-debit notification breach (sent less than 24 hours prior to debit).	gemini	2026-08-22 18:51:28.194151+00
3940	199	intent	merchant	0.9	Session abandoned at fee reveal due to merchant fee shock.	gemini	2026-08-22 18:51:28.194151+00
3941	200	intent	customer_temp	0.9	User abandoned checkout flow at OTP step.	gemini	2026-08-22 18:51:28.194151+00
3942	229	technical	infra	0.95	UPI request timed out at the PSP due to bank server degradation.	gemini	2026-08-22 18:51:28.194151+00
3943	230	intent	merchant	0.9	Session dropped upon fee reveal due to fee shock created by merchant fee presentation.	gemini	2026-08-22 18:51:28.194151+00
3944	232	lifecycle	merchant	0.95	Pre-debit notification sent less than 24 hours prior to recurring debit attempt.	gemini	2026-08-22 18:51:28.194151+00
3945	233	affordability	customer_temp	0.9	Single insufficient balance decline on online payment attempt.	gemini	2026-08-22 18:51:28.194151+00
3946	234	technical	infra	0.95	PSP/bank server degraded causing a timeout error.	gemini	2026-08-22 18:51:28.194151+00
3947	235	technical	infra	0.95	PSP timeout caused by upstream bank degradation.	gemini	2026-08-22 18:51:28.194151+00
3948	236	technical	infra	0.95	Issuer gateway returned a 502 Bad Gateway server error during authorization.	gemini	2026-08-22 18:51:28.194151+00
3949	237	intent	customer_temp	0.85	Customer left before completing the offline QR scan, resulting in abandonment/timeout.	gemini	2026-08-22 18:51:28.194151+00
3950	238	technical	infra	0.95	Issuer gateway returned 502 error during transaction authorization.	gemini	2026-08-22 18:51:28.194151+00
3951	239	affordability	customer_temp	0.9	Single bank decline due to insufficient balance.	gemini	2026-08-22 18:51:28.194151+00
3952	241	intent	customer_temp	0.95	dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3953	242	technical	infra	0.95	UPI request timed out at PSP	groq	2026-08-22 18:51:28.194151+00
3954	243	technical	infra	0.95	Issuer gateway returned 502	groq	2026-08-22 18:51:28.194151+00
3955	244	intent	merchant	0.9	dropped at fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
3956	245	intent	merchant	0.9	dropped at fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
3957	246	lifecycle	merchant	0.9	pre-debit notification sent <24h before debit	groq	2026-08-22 18:51:28.194151+00
3958	247	technical	infra	0.95	UPI request timed out at PSP	groq	2026-08-22 18:51:28.194151+00
3959	248	lifecycle	customer_temp	0.95	card expired	groq	2026-08-22 18:51:28.194151+00
3960	249	affordability	customer_temp	0.95	insufficient balance	groq	2026-08-22 18:51:28.194151+00
3961	250	technical	infra	0.95	UPI request timed out at PSP	groq	2026-08-22 18:51:28.194151+00
4182	261	technical	infra	0.9	UPI bank timeout at PSP	groq	2026-08-22 19:52:40.367338+00
3172	110	intent	merchant	0.9	checkout misconfiguration rejected payload	groq	2026-08-22 16:05:42.239522+00
3173	112	affordability	customer_temp	0.9	bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 16:05:42.239522+00
3174	113	intent	merchant	0.9	checkout misconfiguration rejected payload	groq	2026-08-22 16:05:42.239522+00
3175	126	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit (mandate breach)	groq	2026-08-22 16:05:42.239522+00
3176	127	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 16:05:42.239522+00
3177	128	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-22 16:05:42.239522+00
3178	129	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 16:05:42.239522+00
3179	130	intent	merchant	0.9	session abandoned at fee reveal (fee shock)	groq	2026-08-22 16:05:42.239522+00
3180	132	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit (mandate breach)	groq	2026-08-22 16:05:42.239522+00
3181	133	affordability	customer_temp	0.9	bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 16:05:42.239522+00
4183	262	technical	infra	0.9	UPI bank timeout at PSP	groq	2026-08-22 19:52:40.367338+00
4184	263	technical	infra	0.9	UPI bank timeout at PSP	groq	2026-08-22 19:52:40.367338+00
4185	264	lifecycle	merchant	0.9	Pre‑debit notification sent <24h before debit (mandate breach)	groq	2026-08-22 19:52:40.367338+00
4186	265	intent	merchant	0.9	User abandoned at fee reveal (fee shock)	groq	2026-08-22 19:52:40.367338+00
4187	266	affordability	customer_temp	0.9	Single insufficient balance decline	groq	2026-08-22 19:52:40.367338+00
4188	267	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-22 19:52:40.367338+00
4189	268	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-22 19:52:40.367338+00
4190	269	affordability	customer_structural	0.9	Repeated insufficient balance declines	groq	2026-08-22 19:52:40.367338+00
4191	270	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-22 19:52:40.367338+00
3982	298	lifecycle	merchant	0.9	pre‑debit notification sent <24h (mandate breach)	groq	2026-08-22 18:51:28.194151+00
3983	299	intent	merchant	0.9	user dropped at fee reveal (fee shock/merchant config)	groq	2026-08-22 18:51:28.194151+00
3984	300	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3985	301	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 18:51:28.194151+00
3986	303	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 18:51:28.194151+00
3987	305	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 18:51:28.194151+00
3988	306	intent	merchant	0.9	user dropped at fee reveal (fee shock/merchant config)	groq	2026-08-22 18:51:28.194151+00
3989	307	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
3990	308	intent	merchant	0.9	user dropped at fee reveal (fee shock/merchant config)	groq	2026-08-22 18:51:28.194151+00
3991	309	intent	merchant	0.9	user dropped at fee reveal (fee shock/merchant config)	groq	2026-08-22 18:51:28.194151+00
4212	388	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-22 19:52:40.367338+00
4213	389	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-22 19:52:40.367338+00
4214	391	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-22 19:52:40.367338+00
4215	392	technical	infra	0.9	gateway returned 502 error	groq	2026-08-22 19:52:40.367338+00
4216	393	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-22 19:52:40.367338+00
4217	394	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-22 19:52:40.367338+00
4218	395	affordability	customer_structural	0.9	repeated insufficient balance declines	groq	2026-08-22 19:52:40.367338+00
4219	397	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 19:52:40.367338+00
4220	398	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-22 19:52:40.367338+00
4221	399	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-22 19:52:40.367338+00
4012	336	technical	infra	0.96	gateway returned 502 error	groq	2026-08-22 18:51:28.194151+00
4013	337	intent	customer_temp	0.92	QR scan timed out and customer left	groq	2026-08-22 18:51:28.194151+00
4014	338	technical	infra	0.96	gateway returned 502 error	groq	2026-08-22 18:51:28.194151+00
4015	339	affordability	customer_temp	0.94	single insufficient balance decline	groq	2026-08-22 18:51:28.194151+00
4016	340	lifecycle	customer_temp	0.95	card on file expired	groq	2026-08-22 18:51:28.194151+00
4017	341	intent	customer_temp	0.95	user dropped at OTP step	groq	2026-08-22 18:51:28.194151+00
4018	342	technical	infra	0.96	UPI request timed out at PSP	groq	2026-08-22 18:51:28.194151+00
3242	201	lifecycle	customer_temp	0.9	card expired	groq	2026-08-22 16:05:42.239522+00
3243	202	intent	merchant	0.9	merchant checkout misconfiguration rejected payment payload	groq	2026-08-22 16:05:42.239522+00
3244	203	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 16:05:42.239522+00
3245	205	lifecycle	customer_temp	0.9	card expired	groq	2026-08-22 16:05:42.239522+00
3246	206	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-22 16:05:42.239522+00
3247	207	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 16:05:42.239522+00
3248	208	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-22 16:05:42.239522+00
3249	209	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-22 16:05:42.239522+00
3250	211	affordability	customer_temp	0.9	insufficient balance reported once	groq	2026-08-22 16:05:42.239522+00
3251	214	technical	infra	0.9	issuer gateway returned 502 during authorization	groq	2026-08-22 16:05:42.239522+00
4019	343	technical	infra	0.96	gateway returned 502 error	groq	2026-08-22 18:51:28.194151+00
4020	344	intent	merchant	0.93	customer abandoned at fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
4021	345	intent	merchant	0.93	customer abandoned at fee reveal (fee shock)	groq	2026-08-22 18:51:28.194151+00
4042	412	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 18:51:28.194151+00
4043	414	technical	infra	0.9	gateway 502 error	groq	2026-08-22 18:51:28.194151+00
4044	415	lifecycle	merchant	0.9	pre‑debit notification <24h	groq	2026-08-22 18:51:28.194151+00
4045	418	technical	infra	0.9	gateway 502 error	groq	2026-08-22 18:51:28.194151+00
4046	420	lifecycle	merchant	0.9	pre‑debit notification <24h	groq	2026-08-22 18:51:28.194151+00
4047	421	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 18:51:28.194151+00
4048	422	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-22 18:51:28.194151+00
4049	423	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 18:51:28.194151+00
4050	424	technical	infra	0.9	bank timeout at PSP	groq	2026-08-22 18:51:28.194151+00
4051	426	lifecycle	merchant	0.9	pre‑debit notification <24h	groq	2026-08-22 18:51:28.194151+00
4072	448	lifecycle	customer_temp	0.9	card expired	groq	2026-08-22 18:51:28.194151+00
4073	449	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 18:51:28.194151+00
4074	450	technical	infra	0.9	bank/PSP timeout	groq	2026-08-22 18:51:28.194151+00
4075	451	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 18:51:28.194151+00
4076	452	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 18:51:28.194151+00
4077	453	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-22 18:51:28.194151+00
4078	454	intent	customer_temp	0.9	dropped at OTP	groq	2026-08-22 18:51:28.194151+00
4079	455	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 18:51:28.194151+00
3312	282	affordability	customer_temp	0.9	Bank declined: insufficient balance	groq	2026-08-22 16:05:42.239522+00
3313	285	affordability	customer_temp	0.9	Bank declined: insufficient balance	groq	2026-08-22 16:05:42.239522+00
3314	288	affordability	customer_temp	0.9	Bank declined: insufficient balance	groq	2026-08-22 16:05:42.239522+00
3315	289	affordability	customer_temp	0.9	Bank declined: insufficient balance	groq	2026-08-22 16:05:42.239522+00
3316	291	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 16:05:42.239522+00
3317	292	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-22 16:05:42.239522+00
3318	293	affordability	customer_structural	0.9	4th consecutive cycle declined for insufficient balance	groq	2026-08-22 16:05:42.239522+00
3319	294	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 16:05:42.239522+00
3320	295	affordability	customer_structural	0.9	4th consecutive cycle declined for insufficient balance	groq	2026-08-22 16:05:42.239522+00
3321	297	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-22 16:05:42.239522+00
4080	456	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 18:51:28.194151+00
4081	457	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 18:51:28.194151+00
4092	251	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-22 19:30:15.438492+00
4093	252	lifecycle	merchant	0.9	pre-debit notification sent less than 24h before debit	groq	2026-08-22 19:30:15.438492+00
4094	253	affordability	customer_structural	0.9	repeated insufficient balance across cycles	groq	2026-08-22 19:30:15.438492+00
4095	254	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 19:30:15.438492+00
4096	255	affordability	customer_temp	0.9	single insufficient balance decline	groq	2026-08-22 19:30:15.438492+00
4097	256	lifecycle	merchant	0.9	pre-debit notification sent less than 24h before debit	groq	2026-08-22 19:30:15.438492+00
4098	257	lifecycle	merchant	0.9	pre-debit notification sent less than 24h before debit	groq	2026-08-22 19:30:15.438492+00
4099	258	technical	infra	0.9	gateway returned 5xx error during authorization	groq	2026-08-22 19:30:15.438492+00
4100	259	technical	infra	0.9	UPI request timed out at PSP, bank server degraded	groq	2026-08-22 19:30:15.438492+00
4101	260	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 19:30:15.438492+00
4242	311	affordability	customer_temp	0.96	single insufficient balance decline	groq	2026-08-22 20:06:57.344164+00
4243	314	technical	infra	0.97	gateway 502 error	groq	2026-08-22 20:06:57.344164+00
4244	315	lifecycle	merchant	0.95	pre‑debit notification sent <24h	groq	2026-08-22 20:06:57.344164+00
4245	318	technical	infra	0.97	gateway 502 error	groq	2026-08-22 20:06:57.344164+00
4246	320	lifecycle	merchant	0.95	pre‑debit notification sent <24h	groq	2026-08-22 20:06:57.344164+00
4247	321	affordability	customer_temp	0.96	single insufficient balance decline	groq	2026-08-22 20:06:57.344164+00
4248	322	affordability	customer_structural	0.96	repeated insufficient balance across cycles	groq	2026-08-22 20:06:57.344164+00
4249	323	technical	infra	0.97	UPI bank timeout at PSP	groq	2026-08-22 20:06:57.344164+00
4250	324	technical	infra	0.97	UPI bank timeout at PSP	groq	2026-08-22 20:06:57.344164+00
4251	325	technical	infra	0.94	QR scan timeout, likely gateway/infra issue	groq	2026-08-22 20:06:57.344164+00
4122	326	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-22 19:30:15.438492+00
4123	327	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 19:30:15.438492+00
4124	328	technical	infra	0.9	Issuer gateway returned 502 (gateway error)	groq	2026-08-22 19:30:15.438492+00
4125	329	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 19:30:15.438492+00
4126	330	intent	merchant	0.9	Customer abandoned at fee reveal (fee shock)	groq	2026-08-22 19:30:15.438492+00
4127	331	technical	infra	0.9	QR scan timed out (offline timeout)	groq	2026-08-22 19:30:15.438492+00
4128	332	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit	groq	2026-08-22 19:30:15.438492+00
4129	333	affordability	customer_temp	0.9	Insufficient balance (single occurrence)	groq	2026-08-22 19:30:15.438492+00
4130	334	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 19:30:15.438492+00
4131	335	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 19:30:15.438492+00
4272	492	technical	infra	0.94	Issuer gateway returned 502 during authorization	groq	2026-08-22 20:06:57.344164+00
4273	493	affordability	customer_structural	0.94	Repeated insufficient balance across cycles	groq	2026-08-22 20:06:57.344164+00
4274	494	technical	infra	0.94	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 20:06:57.344164+00
4275	495	affordability	customer_structural	0.94	Repeated insufficient balance across cycles	groq	2026-08-22 20:06:57.344164+00
4276	497	lifecycle	customer_temp	0.94	Card on file expired	groq	2026-08-22 20:06:57.344164+00
4277	498	lifecycle	merchant	0.94	Pre-debit notification sent <24h before debit	groq	2026-08-22 20:06:57.344164+00
4278	499	intent	customer_temp	0.93	User abandoned session at fee reveal step	groq	2026-08-22 20:06:57.344164+00
4279	500	intent	customer_temp	0.93	User abandoned at OTP step	groq	2026-08-22 20:06:57.344164+00
4280	486	intent	customer_temp	0.92	QR scan timed out in-store; customer left before completion	groq	2026-08-22 20:06:57.344164+00
4281	487	intent	customer_temp	0.92	QR scan timed out in-store; customer left before completion	groq	2026-08-22 20:06:57.344164+00
3392	377	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-22 16:05:42.239522+00
3393	379	intent	merchant	0.9	user abandoned after seeing fees (fee shock)	groq	2026-08-22 16:05:42.239522+00
3394	380	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-22 16:05:42.239522+00
3395	381	technical	infra	0.9	UPI request timed out at PSP	groq	2026-08-22 16:05:42.239522+00
3396	382	affordability	customer_temp	0.9	insufficient balance (single occurrence)	groq	2026-08-22 16:05:42.239522+00
3397	383	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 16:05:42.239522+00
3398	384	lifecycle	customer_temp	0.9	card on file expired	groq	2026-08-22 16:05:42.239522+00
3399	385	affordability	customer_structural	0.9	insufficient balance (repeated occurrence)	groq	2026-08-22 16:05:42.239522+00
3400	386	intent	customer_temp	0.9	QR scan timed out; customer left	groq	2026-08-22 16:05:42.239522+00
3401	387	intent	customer_temp	0.9	QR scan timed out; customer left	groq	2026-08-22 16:05:42.239522+00
4152	427	technical	infra	0.95	UPI bank timeout at PSP	groq	2026-08-22 19:30:15.438492+00
4153	428	technical	infra	0.95	Issuer gateway returned 502	groq	2026-08-22 19:30:15.438492+00
4154	429	technical	infra	0.95	UPI bank timeout at PSP	groq	2026-08-22 19:30:15.438492+00
4155	430	intent	merchant	0.85	User abandoned at fee reveal (fee shock)	groq	2026-08-22 19:30:15.438492+00
4156	431	intent	customer_temp	0.95	QR scan timed out, customer left before completing payment	groq	2026-08-22 19:30:15.438492+00
4157	432	lifecycle	merchant	0.95	Pre‑debit notification sent less than 24 h before debit	groq	2026-08-22 19:30:15.438492+00
4158	433	affordability	customer_temp	0.95	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 19:30:15.438492+00
4159	434	technical	infra	0.95	UPI bank timeout at PSP	groq	2026-08-22 19:30:15.438492+00
4160	435	technical	infra	0.95	UPI bank timeout at PSP	groq	2026-08-22 19:30:15.438492+00
4161	436	technical	infra	0.95	Issuer gateway returned 502	groq	2026-08-22 19:30:15.438492+00
4292	437	technical	infra	0.9	QR scan timed out (offline) indicates a technical infra issue	groq	2026-08-22 20:17:27.431052+00
4293	438	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-22 20:17:27.431052+00
4294	439	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 20:17:27.431052+00
4295	441	intent	customer_temp	0.9	User dropped at OTP step	groq	2026-08-22 20:17:27.431052+00
4296	442	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 20:17:27.431052+00
4297	443	technical	infra	0.9	Issuer gateway returned 502 during authorization	groq	2026-08-22 20:17:27.431052+00
4298	444	intent	merchant	0.9	User abandoned at fee reveal (fee shock)	groq	2026-08-22 20:17:27.431052+00
4299	445	intent	merchant	0.9	User abandoned at fee reveal (fee shock)	groq	2026-08-22 20:17:27.431052+00
4300	446	lifecycle	merchant	0.9	Pre-debit notification sent <24h before debit (mandate breach)	groq	2026-08-22 20:17:27.431052+00
4301	447	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 20:17:27.431052+00
3551	74	intent	customer_temp	0.85	User dropped at OTP step with no other failure signals.	gemini	2026-08-22 16:50:40.649933+00
3552	75	intent	merchant	0.9	user abandoned after seeing fees (fee shock) – merchant‑related cause	groq	2026-08-22 16:50:40.649933+00
3553	76	technical	merchant	0.9	checkout misconfiguration rejected the payload – merchant side technical issue	groq	2026-08-22 16:50:40.649933+00
3554	77	intent	customer_temp	0.9	user dropped at OTP step, no other signal	groq	2026-08-22 16:50:40.649933+00
3555	79	intent	merchant	0.9	user abandoned after fee reveal – fee shock caused by merchant	groq	2026-08-22 16:50:40.649933+00
3556	80	technical	infra	0.9	UPI request timed out at PSP/bank – infra technical failure	groq	2026-08-22 16:50:40.649933+00
3557	81	technical	infra	0.9	UPI request timed out at PSP/bank – infra technical failure	groq	2026-08-22 16:50:40.649933+00
3558	82	affordability	customer_temp	0.9	bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 16:50:40.649933+00
3559	83	lifecycle	customer_temp	0.9	card on file expired – lifecycle issue	groq	2026-08-22 16:50:40.649933+00
3560	84	lifecycle	customer_temp	0.9	card on file expired – lifecycle issue	groq	2026-08-22 16:50:40.649933+00
3561	85	affordability	customer_temp	0.9	bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 16:50:40.649933+00
3562	87	intent	customer_temp	0.85	Customer left in-store before completing the QR scan payment.	gemini	2026-08-22 16:50:40.649933+00
3563	88	affordability	customer_temp	0.95	Single decline due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3564	89	affordability	customer_temp	0.95	Single decline due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3565	91	technical	infra	0.95	UPI request timed out due to degraded bank servers.	gemini	2026-08-22 16:50:40.649933+00
3566	92	technical	infra	0.95	Issuer gateway returned a 502 server error during authorization.	gemini	2026-08-22 16:50:40.649933+00
3567	93	affordability	customer_structural	0.95	Repeated declines over 4 consecutive cycles due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3568	78	technical	merchant	0.95	Merchant checkout misconfiguration caused payment payload rejection.	gemini	2026-08-22 16:50:40.649933+00
3569	94	technical	infra	0.95	UPI request timed out due to degraded bank servers.	gemini	2026-08-22 16:50:40.649933+00
3570	95	affordability	customer_structural	0.95	Repeated declines over 4 consecutive cycles due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3571	96	intent	customer_temp	0.85	Customer left in-store before completing the QR scan payment.	gemini	2026-08-22 16:50:40.649933+00
4302	356	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit (mandate notification breach)	groq	2026-08-22 20:26:29.077762+00
4303	357	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit (mandate notification breach)	groq	2026-08-22 20:26:29.077762+00
4304	358	technical	infra	0.9	issuer gateway returned 502 (gateway 5xx error)	groq	2026-08-22 20:26:29.077762+00
4305	359	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 20:26:29.077762+00
4306	360	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 20:26:29.077762+00
4307	361	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 20:26:29.077762+00
4308	362	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 20:26:29.077762+00
4309	363	technical	infra	0.9	UPI request timed out at PSP (bank timeout)	groq	2026-08-22 20:26:29.077762+00
4310	364	lifecycle	merchant	0.9	pre‑debit notification sent <24h before debit (mandate notification breach)	groq	2026-08-22 20:26:29.077762+00
4311	365	intent	merchant	0.9	user abandoned after fee reveal (fee shock)	groq	2026-08-22 20:26:29.077762+00
3602	146	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 16:50:40.649933+00
3603	147	technical	infra	0.9	bank timeout	groq	2026-08-22 16:50:40.649933+00
3604	148	lifecycle	customer_temp	0.9	card expired	groq	2026-08-22 16:50:40.649933+00
3605	149	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 16:50:40.649933+00
3606	150	technical	infra	0.9	bank timeout	groq	2026-08-22 16:50:40.649933+00
3607	151	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 16:50:40.649933+00
3608	152	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 16:50:40.649933+00
3609	153	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-22 16:50:40.649933+00
3610	154	intent	customer_temp	0.9	dropped at OTP	groq	2026-08-22 16:50:40.649933+00
3611	155	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 16:50:40.649933+00
4312	501	technical	infra	0.95	bank session timed out	groq	2026-08-22 20:57:20.308257+00
3652	215	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 16:50:40.649933+00
3653	218	technical	infra	0.9	gateway 5xx error	groq	2026-08-22 16:50:40.649933+00
3654	220	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 16:50:40.649933+00
3655	221	affordability	customer_temp	0.9	insufficient balance	groq	2026-08-22 16:50:40.649933+00
3656	222	affordability	customer_structural	0.9	repeated insufficient balance	groq	2026-08-22 16:50:40.649933+00
3657	223	technical	infra	0.9	bank timeout	groq	2026-08-22 16:50:40.649933+00
3658	224	technical	infra	0.9	bank timeout	groq	2026-08-22 16:50:40.649933+00
3659	226	lifecycle	merchant	0.9	pre-debit notification <24h	groq	2026-08-22 16:50:40.649933+00
3660	227	technical	infra	0.9	bank timeout	groq	2026-08-22 16:50:40.649933+00
3661	228	technical	infra	0.9	gateway 5xx error	groq	2026-08-22 16:50:40.649933+00
3702	271	affordability	customer_structural	0.9	repeated insufficient balance across cycles	groq	2026-08-22 16:50:40.649933+00
3703	272	affordability	customer_structural	0.9	repeated insufficient balance across cycles	groq	2026-08-22 16:50:40.649933+00
3704	273	lifecycle	customer_temp	0.9	card expired	groq	2026-08-22 16:50:40.649933+00
3705	274	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-22 16:50:40.649933+00
3706	275	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-22 16:50:40.649933+00
3707	276	technical	merchant	0.9	checkout configuration error	groq	2026-08-22 16:50:40.649933+00
3708	277	intent	customer_temp	0.9	dropped at OTP step	groq	2026-08-22 16:50:40.649933+00
3709	279	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-22 16:50:40.649933+00
3710	280	technical	infra	0.9	UPI bank timeout	groq	2026-08-22 16:50:40.649933+00
3711	281	technical	infra	0.9	UPI bank timeout	groq	2026-08-22 16:50:40.649933+00
3752	346	lifecycle	merchant	0.95	pre‑debit notification sent <24h	groq	2026-08-22 16:50:40.649933+00
3753	347	technical	infra	0.95	UPI request timed out at PSP	groq	2026-08-22 16:50:40.649933+00
3754	348	lifecycle	customer_temp	0.95	card on file expired	groq	2026-08-22 16:50:40.649933+00
3755	349	affordability	customer_temp	0.95	single insufficient balance decline	groq	2026-08-22 16:50:40.649933+00
3756	350	technical	infra	0.95	UPI request timed out at PSP	groq	2026-08-22 16:50:40.649933+00
3757	351	affordability	customer_temp	0.95	single insufficient balance decline	groq	2026-08-22 16:50:40.649933+00
3758	352	lifecycle	merchant	0.95	pre‑debit notification sent <24h	groq	2026-08-22 16:50:40.649933+00
3759	353	affordability	customer_structural	0.95	repeated insufficient balance declines	groq	2026-08-22 16:50:40.649933+00
3760	354	intent	customer_temp	0.95	dropped at OTP step	groq	2026-08-22 16:50:40.649933+00
3761	355	affordability	customer_temp	0.95	single insufficient balance decline	groq	2026-08-22 16:50:40.649933+00
3772	366	affordability	customer_temp	0.95	Single insufficient balance decline indicates temporary customer liquidity issue.	gemini	2026-08-22 16:50:40.649933+00
3773	367	intent	customer_temp	0.95	User dropped off at the OTP step without explicit payment system errors.	gemini	2026-08-22 16:50:40.649933+00
3774	368	intent	customer_temp	0.95	User abandoned transaction at OTP verification.	gemini	2026-08-22 16:50:40.649933+00
3775	369	affordability	customer_temp	0.95	Insufficient funds decline during single transaction attempt.	gemini	2026-08-22 16:50:40.649933+00
3776	370	intent	customer_temp	0.95	User abandoned transaction at OTP prompt.	gemini	2026-08-22 16:50:40.649933+00
3777	371	affordability	customer_structural	0.95	Four consecutive cycles failing due to insufficient balance signifies structural customer affordability issues.	gemini	2026-08-22 16:50:40.649933+00
3778	372	affordability	customer_structural	0.95	Repeated failures across multiple billing cycles due to insufficient balance indicate a structural customer issue.	gemini	2026-08-22 16:50:40.649933+00
3779	373	lifecycle	customer_temp	0.95	Expired payment instrument on file is a temporary customer lifecycle issue requiring card update.	gemini	2026-08-22 16:50:40.649933+00
3780	374	intent	customer_temp	0.95	User dropped off during the OTP step.	gemini	2026-08-22 16:50:40.649933+00
3781	375	intent	merchant	0.95	Checkout abandonment at fee reveal indicates merchant-driven fee shock.	gemini	2026-08-22 16:50:40.649933+00
3792	400	intent	customer_temp	0.9	User dropped at OTP step, no further signal	groq	2026-08-22 16:50:40.649933+00
3793	401	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-22 16:50:40.649933+00
3794	402	intent	merchant	0.9	Merchant checkout misconfiguration rejected payment payload	groq	2026-08-22 16:50:40.649933+00
3795	403	technical	infra	0.9	UPI request timed out at PSP; bank server degraded	groq	2026-08-22 16:50:40.649933+00
3796	405	lifecycle	customer_temp	0.9	Card on file expired	groq	2026-08-22 16:50:40.649933+00
3797	406	intent	merchant	0.9	User dropped at fee reveal (fee shock) before payment attempt	groq	2026-08-22 16:50:40.649933+00
3798	407	intent	customer_temp	0.9	User dropped at OTP step, no further signal	groq	2026-08-22 16:50:40.649933+00
3799	408	intent	merchant	0.9	User dropped at fee reveal (fee shock) before payment attempt	groq	2026-08-22 16:50:40.649933+00
3800	409	intent	merchant	0.9	User dropped at fee reveal (fee shock) before payment attempt	groq	2026-08-22 16:50:40.649933+00
3801	411	affordability	customer_temp	0.9	Bank declined due to insufficient balance (single occurrence)	groq	2026-08-22 16:50:40.649933+00
3842	458	technical	infra	0.9	gateway 502 error	groq	2026-08-22 16:50:40.649933+00
3843	459	technical	infra	0.9	UPI timeout at PSP	groq	2026-08-22 16:50:40.649933+00
3844	460	intent	customer_temp	0.9	dropped at OTP	groq	2026-08-22 16:50:40.649933+00
3845	461	technical	infra	0.9	UPI timeout at PSP	groq	2026-08-22 16:50:40.649933+00
3846	462	technical	infra	0.9	UPI timeout at PSP	groq	2026-08-22 16:50:40.649933+00
3847	463	technical	infra	0.9	UPI timeout at PSP	groq	2026-08-22 16:50:40.649933+00
3848	464	lifecycle	merchant	0.9	pre‑debit notification sent <24h	groq	2026-08-22 16:50:40.649933+00
3849	465	intent	merchant	0.9	user abandoned at fee reveal (fee shock)	groq	2026-08-22 16:50:40.649933+00
3850	466	affordability	customer_temp	0.9	insufficient balance reported	groq	2026-08-22 16:50:40.649933+00
3851	467	intent	customer_temp	0.9	dropped at OTP	groq	2026-08-22 16:50:40.649933+00
3852	479	intent	merchant	0.95	Customer abandoned session upon fee reveal (fee shock), which is owned by merchant fee presentation.	gemini	2026-08-22 16:50:40.649933+00
3853	480	technical	infra	0.95	UPI request timed out at PSP due to degraded bank servers.	gemini	2026-08-22 16:50:40.649933+00
3854	481	technical	infra	0.95	UPI request timed out at PSP due to degraded bank servers.	gemini	2026-08-22 16:50:40.649933+00
3855	482	affordability	customer_temp	0.9	Transaction declined by bank due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3856	483	lifecycle	customer_temp	0.95	Recurring payment failed because card on file has expired.	gemini	2026-08-22 16:50:40.649933+00
3857	484	lifecycle	customer_temp	0.95	Recurring payment failed because card on file has expired.	gemini	2026-08-22 16:50:40.649933+00
3858	485	affordability	customer_temp	0.9	Transaction declined by bank due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3859	488	affordability	customer_temp	0.9	Transaction declined by bank due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3860	489	affordability	customer_temp	0.9	Transaction declined by bank due to insufficient balance.	gemini	2026-08-22 16:50:40.649933+00
3861	491	technical	infra	0.95	UPI request timed out at PSP due to degraded bank servers.	gemini	2026-08-22 16:50:40.649933+00
3472	468	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 16:05:42.239522+00
3473	470	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 16:05:42.239522+00
3474	471	affordability	customer_structural	0.9	repeated insufficient balance across cycles	groq	2026-08-22 16:05:42.239522+00
3475	472	affordability	customer_structural	0.9	repeated insufficient balance across cycles	groq	2026-08-22 16:05:42.239522+00
3476	473	lifecycle	customer_temp	0.9	card on file has expired	groq	2026-08-22 16:05:42.239522+00
3477	474	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 16:05:42.239522+00
3478	475	intent	merchant	0.9	user abandoned after seeing fee shock	groq	2026-08-22 16:05:42.239522+00
3479	476	technical	merchant	0.9	merchant checkout misconfiguration rejected payload	groq	2026-08-22 16:05:42.239522+00
3480	477	intent	customer_temp	0.9	user dropped at OTP step	groq	2026-08-22 16:05:42.239522+00
3481	478	technical	merchant	0.9	merchant checkout misconfiguration rejected payload	groq	2026-08-22 16:05:42.239522+00
\.


--
-- Data for Name: gate_decisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gate_decisions (id, failure_id, rule_id, verdict, context_snapshot, created_at) FROM stdin;
8002	501	TECH_RETRY	ALLOW	\N	2026-08-22 20:57:20.308257+00
7502	16	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7503	17	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7504	19	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7505	116	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7506	117	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7507	119	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7508	125	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7509	131	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7510	137	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7511	187	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7512	196	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7513	204	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7514	178	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7515	210	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7516	296	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7517	304	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7518	316	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7519	317	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7520	319	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7521	396	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7522	404	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7523	416	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7524	417	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7525	419	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7526	290	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7527	302	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7528	310	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7529	312	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7530	313	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7531	376	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7532	73	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7533	378	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7534	390	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7535	410	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7536	413	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7537	490	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7538	10	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7539	12	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7540	13	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7541	86	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7542	90	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7543	102	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7544	185	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7545	212	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7546	213	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7547	469	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7548	37	OFFLINE_QR_TRAP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7549	121	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7550	216	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7551	217	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7552	219	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7553	225	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7554	231	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7555	278	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7556	286	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7557	287	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7558	425	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7559	496	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7560	140	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7561	44	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7562	45	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7563	158	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7564	240	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7565	283	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7566	284	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7567	440	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7568	4	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7569	1	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7570	3	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7571	5	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7572	6	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7573	7	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7574	8	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7575	9	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7576	11	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7577	14	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7578	15	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7579	18	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7580	20	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7581	21	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7582	22	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7583	23	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7584	24	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7585	26	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7586	27	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7587	28	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7588	29	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7589	30	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7590	2	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7591	25	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7592	32	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7593	33	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7594	34	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7595	35	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7596	36	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7597	38	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7598	40	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7599	41	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7600	42	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7601	43	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7602	46	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7603	47	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7604	48	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7605	49	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7606	50	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7607	51	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7608	52	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7609	53	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7610	54	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7611	55	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7612	56	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7613	57	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7614	58	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7615	59	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7616	60	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7617	61	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7618	39	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7619	31	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7620	62	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7621	63	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7622	64	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7623	65	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7624	66	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7625	67	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7626	68	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7627	69	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7628	70	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7629	71	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7630	72	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7631	74	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7632	75	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7633	76	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7634	77	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7635	79	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7636	80	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7637	81	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7638	82	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7639	83	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7640	84	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7641	85	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7642	88	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7643	89	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7644	91	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7645	92	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7646	93	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7647	87	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7648	78	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7649	94	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7650	95	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7651	97	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7652	98	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7653	99	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7654	100	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7655	101	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7656	103	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7657	104	OFFLINE_QR_TRAP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7658	105	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7659	106	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7660	107	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7661	108	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7662	111	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7663	114	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7664	115	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7665	118	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7666	120	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7667	122	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7668	123	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7669	124	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7670	110	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7671	113	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7672	109	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7673	112	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7674	96	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7675	126	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7676	127	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7677	128	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7678	129	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7679	130	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7680	132	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7681	133	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7682	134	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7683	135	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7684	136	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7685	138	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7686	139	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7687	141	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7688	142	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7689	143	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7690	144	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7691	145	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7692	146	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7693	147	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7694	148	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7695	149	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7696	150	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7697	151	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7698	152	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7699	153	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7700	154	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7701	155	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7702	156	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7703	157	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7704	159	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7705	160	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7706	161	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7707	162	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7708	163	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7709	164	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7710	165	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7711	166	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7712	167	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7713	168	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7714	169	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7715	170	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7716	171	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7717	172	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7718	173	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7719	174	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7720	175	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7721	176	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7722	177	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7723	179	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7724	180	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7725	181	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7726	182	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7727	183	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7728	184	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7729	186	OFFLINE_QR_TRAP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7730	188	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7731	189	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7732	190	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7733	191	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7734	192	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7735	193	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7736	194	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7737	195	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7738	197	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7739	198	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7740	199	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7741	200	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7742	201	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7743	203	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7744	205	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7745	206	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7746	207	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7747	208	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7748	209	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7749	211	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7750	214	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7751	215	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7752	218	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7753	202	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7754	220	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7755	221	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7756	222	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7757	223	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7758	224	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7759	226	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7760	227	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7761	228	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7762	229	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7763	230	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7764	232	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7765	233	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7766	234	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7767	235	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7768	236	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7769	238	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7770	239	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7771	241	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7772	242	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7773	243	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7774	244	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7775	245	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7776	246	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7777	247	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7778	248	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7779	249	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7780	250	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7781	251	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7782	237	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7783	252	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7784	253	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7785	254	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7786	255	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7787	256	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7788	257	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7789	258	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7790	259	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7791	260	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7792	261	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7793	262	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7794	263	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7795	264	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7796	265	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7797	266	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7798	267	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7799	268	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7800	270	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7801	271	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7802	272	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7803	273	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7804	274	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7805	275	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7806	276	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7807	277	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7808	279	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7809	280	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7810	281	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7811	282	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7812	269	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7813	285	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7814	288	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7815	289	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7816	291	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7817	292	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7818	293	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7819	294	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7820	295	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7821	297	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7822	298	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7823	299	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7824	300	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7825	301	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7826	303	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7827	305	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7828	306	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7829	307	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7830	308	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7831	309	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7832	311	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7833	314	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7834	315	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7835	318	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7836	320	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7837	321	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7838	322	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7839	323	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7840	324	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7841	325	OFFLINE_QR_TRAP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7842	326	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7843	327	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7844	328	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7845	329	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7846	330	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7847	331	OFFLINE_QR_TRAP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7848	332	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7849	333	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7850	334	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7851	335	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7852	336	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7853	338	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7854	339	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7855	340	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7856	341	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7857	342	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7858	343	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7859	344	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7860	345	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7861	346	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7862	337	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7863	347	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7864	348	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7865	349	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7866	350	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7867	351	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7868	352	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7869	353	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7870	354	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7871	355	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7872	356	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7873	357	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7874	358	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7875	359	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7876	360	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7877	361	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7878	362	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7879	363	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7880	364	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7881	365	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7882	366	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7883	367	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7884	368	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7885	369	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7886	370	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7887	371	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7888	372	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7889	373	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7890	374	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7891	375	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7892	377	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7893	379	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7894	380	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7895	381	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7896	382	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7897	383	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7898	384	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7899	388	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7900	389	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7901	391	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7902	392	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7903	393	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7904	394	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7905	395	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7906	397	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7907	398	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7908	399	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7909	400	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7910	401	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7911	403	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7912	405	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7913	406	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7914	407	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7915	408	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7916	385	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7917	386	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7918	387	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7919	402	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7920	409	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7921	411	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7922	412	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7923	414	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7924	415	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7925	418	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7926	420	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7927	421	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7928	422	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7929	423	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7930	424	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7931	426	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7932	427	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7933	428	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7934	429	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7935	430	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7936	432	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7937	433	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7938	434	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7939	435	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7940	436	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7941	437	OFFLINE_QR_TRAP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7942	438	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7943	439	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7944	431	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7945	441	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7946	442	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7947	443	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7948	444	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7949	445	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7950	446	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7951	447	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7952	448	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7953	449	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7954	450	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7955	451	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7956	452	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7957	453	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7958	454	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7959	455	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7960	456	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7961	457	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7962	458	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7963	459	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7964	460	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7965	461	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7966	462	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7967	463	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7968	464	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7969	465	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7970	466	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7971	467	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7972	468	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7973	470	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7974	471	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7975	472	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7976	473	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7977	474	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7978	475	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7979	476	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7980	477	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7981	478	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7982	479	FEE_SHOCK	BLOCK	\N	2026-08-22 20:53:04.852175+00
7983	480	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7984	481	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7985	482	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7986	483	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7987	484	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7988	485	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7989	488	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7990	489	LIQUIDITY_DEFER	DEFER	\N	2026-08-22 20:53:04.852175+00
7991	491	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7992	492	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7993	493	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7994	494	TECH_RETRY	ALLOW	\N	2026-08-22 20:53:04.852175+00
7995	495	STRUCTURAL_STOP	BLOCK	\N	2026-08-22 20:53:04.852175+00
7996	497	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7997	498	RBI_MANDATE	BLOCK	\N	2026-08-22 20:53:04.852175+00
7998	500	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
7999	486	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
8000	487	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
8001	499	DEFAULT_ALLOW	ALLOW	\N	2026-08-22 20:53:04.852175+00
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, failure_id, kind, run_at, attempts, max_attempts, status, last_error) FROM stdin;
547	312	DEFERRED_RETRY	2026-08-31 16:34:00+00	0	3	queued	\N
548	12	DEFERRED_RETRY	2026-09-02 16:32:00+00	0	3	queued	\N
549	185	DEFERRED_RETRY	2026-09-04 16:49:00+00	0	3	queued	\N
550	212	DEFERRED_RETRY	2026-09-04 15:55:00+00	0	3	queued	\N
551	469	DEFERRED_RETRY	2026-09-03 10:17:00+00	0	3	queued	\N
552	121	DEFERRED_RETRY	2026-09-02 13:38:00+00	0	3	queued	\N
553	11	DEFERRED_RETRY	2026-09-02 17:28:00+00	0	3	queued	\N
554	21	DEFERRED_RETRY	2026-09-03 08:42:00+00	0	3	queued	\N
555	33	DEFERRED_RETRY	2026-09-04 19:21:00+00	0	3	queued	\N
556	49	DEFERRED_RETRY	2026-09-01 16:29:00+00	0	3	queued	\N
557	51	DEFERRED_RETRY	2026-09-04 21:44:00+00	0	3	queued	\N
558	55	DEFERRED_RETRY	2026-09-03 15:38:00+00	0	3	queued	\N
559	66	DEFERRED_RETRY	2026-09-02 11:08:00+00	0	3	queued	\N
560	69	DEFERRED_RETRY	2026-09-04 21:41:00+00	0	3	queued	\N
561	82	DEFERRED_RETRY	2026-09-03 15:39:00+00	0	3	queued	\N
562	85	DEFERRED_RETRY	2026-08-31 12:04:00+00	0	3	queued	\N
563	88	DEFERRED_RETRY	2026-09-01 22:56:00+00	0	3	queued	\N
564	89	DEFERRED_RETRY	2026-09-02 20:26:00+00	0	3	queued	\N
565	111	DEFERRED_RETRY	2026-09-03 12:24:00+00	0	3	queued	\N
566	112	DEFERRED_RETRY	2026-09-04 19:04:00+00	0	3	queued	\N
567	133	DEFERRED_RETRY	2026-09-02 18:06:00+00	0	3	queued	\N
568	139	DEFERRED_RETRY	2026-09-01 12:09:00+00	0	3	queued	\N
569	149	DEFERRED_RETRY	2026-09-02 12:53:00+00	0	3	queued	\N
570	151	DEFERRED_RETRY	2026-09-03 20:32:00+00	0	3	queued	\N
571	155	DEFERRED_RETRY	2026-09-04 10:01:00+00	0	3	queued	\N
572	166	DEFERRED_RETRY	2026-09-03 13:51:00+00	0	3	queued	\N
573	169	DEFERRED_RETRY	2026-09-03 09:48:00+00	0	3	queued	\N
574	182	DEFERRED_RETRY	2026-09-02 10:36:00+00	0	3	queued	\N
575	188	DEFERRED_RETRY	2026-08-31 19:45:00+00	0	3	queued	\N
576	189	DEFERRED_RETRY	2026-09-04 17:54:00+00	0	3	queued	\N
577	211	DEFERRED_RETRY	2026-09-01 11:03:00+00	0	3	queued	\N
578	221	DEFERRED_RETRY	2026-09-04 11:08:00+00	0	3	queued	\N
579	233	DEFERRED_RETRY	2026-09-03 21:32:00+00	0	3	queued	\N
580	239	DEFERRED_RETRY	2026-09-02 19:35:00+00	0	3	queued	\N
581	249	DEFERRED_RETRY	2026-09-01 09:58:00+00	0	3	queued	\N
582	251	DEFERRED_RETRY	2026-09-02 08:19:00+00	0	3	queued	\N
583	255	DEFERRED_RETRY	2026-08-31 17:36:00+00	0	3	queued	\N
584	266	DEFERRED_RETRY	2026-09-01 12:10:00+00	0	3	queued	\N
585	282	DEFERRED_RETRY	2026-08-31 22:38:00+00	0	3	queued	\N
586	285	DEFERRED_RETRY	2026-09-04 15:19:00+00	0	3	queued	\N
587	288	DEFERRED_RETRY	2026-09-03 19:41:00+00	0	3	queued	\N
588	289	DEFERRED_RETRY	2026-09-02 21:09:00+00	0	3	queued	\N
589	311	DEFERRED_RETRY	2026-09-03 08:34:00+00	0	3	queued	\N
590	321	DEFERRED_RETRY	2026-09-02 10:43:00+00	0	3	queued	\N
591	333	DEFERRED_RETRY	2026-09-02 12:05:00+00	0	3	queued	\N
592	339	DEFERRED_RETRY	2026-08-31 21:17:00+00	0	3	queued	\N
593	349	DEFERRED_RETRY	2026-09-02 21:43:00+00	0	3	queued	\N
594	351	DEFERRED_RETRY	2026-09-03 22:38:00+00	0	3	queued	\N
595	355	DEFERRED_RETRY	2026-09-03 08:06:00+00	0	3	queued	\N
596	366	DEFERRED_RETRY	2026-09-03 20:00:00+00	0	3	queued	\N
597	369	DEFERRED_RETRY	2026-09-02 18:38:00+00	0	3	queued	\N
598	382	DEFERRED_RETRY	2026-09-03 23:35:00+00	0	3	queued	\N
599	388	DEFERRED_RETRY	2026-09-04 13:39:00+00	0	3	queued	\N
600	389	DEFERRED_RETRY	2026-09-01 19:34:00+00	0	3	queued	\N
601	411	DEFERRED_RETRY	2026-09-01 08:39:00+00	0	3	queued	\N
602	412	DEFERRED_RETRY	2026-09-02 12:58:00+00	0	3	queued	\N
603	421	DEFERRED_RETRY	2026-09-03 08:37:00+00	0	3	queued	\N
604	433	DEFERRED_RETRY	2026-09-03 19:03:00+00	0	3	queued	\N
605	439	DEFERRED_RETRY	2026-09-02 09:11:00+00	0	3	queued	\N
606	449	DEFERRED_RETRY	2026-09-02 10:37:00+00	0	3	queued	\N
607	451	DEFERRED_RETRY	2026-08-31 12:15:00+00	0	3	queued	\N
608	455	DEFERRED_RETRY	2026-09-03 19:49:00+00	0	3	queued	\N
609	466	DEFERRED_RETRY	2026-08-31 21:11:00+00	0	3	queued	\N
610	482	DEFERRED_RETRY	2026-08-31 14:51:00+00	0	3	queued	\N
611	485	DEFERRED_RETRY	2026-09-02 19:45:00+00	0	3	queued	\N
612	488	DEFERRED_RETRY	2026-09-04 15:42:00+00	0	3	queued	\N
613	489	DEFERRED_RETRY	2026-09-03 17:08:00+00	0	3	queued	\N
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
501	pay_TSOALEUJL823Wr	live	49900	INR	netbanking	NB_SESSION_TIMEOUT	Netbanking session timed out at bank page	cust_live_001	merch_001	in_session_online	t	\N	\N	\N	\N	\N	\N	recovered	49900	0	2025-08-19 16:10:00+00	2026-08-22 04:52:07.958557+00
16	pay_sim_0015	synthetic	440000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_023	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	440000	440000	2026-08-21 22:58:00+00	2026-08-21 11:47:09.172994+00
17	pay_sim_0016	synthetic	494400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_036	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	494400	494400	2026-08-14 23:05:00+00	2026-08-21 11:47:09.172994+00
19	pay_sim_0018	synthetic	285000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_014	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	285000	285000	2026-08-14 23:18:00+00	2026-08-21 11:47:09.172994+00
116	pay_sim_0115	synthetic	311300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_080	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	311300	311300	2026-08-03 21:54:00+00	2026-08-21 11:47:09.172994+00
117	pay_sim_0116	synthetic	371800	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_014	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	371800	371800	2026-08-19 20:33:00+00	2026-08-21 11:47:09.172994+00
119	pay_sim_0118	synthetic	77400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_043	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	77400	77400	2026-08-17 11:33:00+00	2026-08-21 11:47:09.172994+00
125	pay_sim_0124	synthetic	499300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_039	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	499300	499300	2026-08-02 19:32:00+00	2026-08-21 11:47:09.172994+00
131	pay_sim_0130	synthetic	374800	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_032	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	374800	374800	2026-08-17 13:23:00+00	2026-08-21 11:47:09.172994+00
137	pay_sim_0136	synthetic	446100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_043	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	446100	446100	2026-08-03 21:32:00+00	2026-08-21 11:47:09.172994+00
187	pay_sim_0186	synthetic	115300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_063	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	115300	115300	2026-08-05 10:28:00+00	2026-08-21 11:47:09.172994+00
196	pay_sim_0195	synthetic	297100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_060	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	297100	297100	2026-08-05 13:49:00+00	2026-08-21 11:47:09.172994+00
204	pay_sim_0203	synthetic	187500	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_074	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	187500	187500	2026-08-25 21:39:00+00	2026-08-21 11:47:09.172994+00
178	pay_sim_0177	synthetic	61800	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_056	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	61800	61800	2026-08-03 20:23:00+00	2026-08-21 11:47:09.172994+00
210	pay_sim_0209	synthetic	276300	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_072	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	276300	276300	2026-08-08 22:07:00+00	2026-08-21 11:47:09.172994+00
296	pay_sim_0295	synthetic	192600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_076	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	192600	192600	2026-08-16 14:55:00+00	2026-08-21 11:47:09.172994+00
304	pay_sim_0303	synthetic	285100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_020	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	285100	285100	2026-08-08 20:36:00+00	2026-08-21 11:47:09.172994+00
316	pay_sim_0315	synthetic	390900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_048	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	390900	390900	2026-08-19 15:44:00+00	2026-08-21 11:47:09.172994+00
317	pay_sim_0316	synthetic	80900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_029	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	80900	80900	2026-08-21 09:05:00+00	2026-08-21 11:47:09.172994+00
319	pay_sim_0318	synthetic	82600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_002	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	82600	82600	2026-08-16 21:41:00+00	2026-08-21 11:47:09.172994+00
396	pay_sim_0395	synthetic	317200	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_066	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	317200	317200	2026-08-15 23:20:00+00	2026-08-21 11:47:09.172994+00
404	pay_sim_0403	synthetic	150400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_011	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	150400	150400	2026-08-02 20:40:00+00	2026-08-21 11:47:09.172994+00
416	pay_sim_0415	synthetic	248300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_071	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	248300	248300	2026-08-25 08:54:00+00	2026-08-21 11:47:09.172994+00
417	pay_sim_0416	synthetic	439000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_039	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	439000	439000	2026-08-20 14:47:00+00	2026-08-21 11:47:09.172994+00
419	pay_sim_0418	synthetic	212300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_050	merch_001	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	212300	212300	2026-08-16 10:33:00+00	2026-08-21 11:47:09.172994+00
290	pay_sim_0289	synthetic	165500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_039	merch_004	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	165500	165500	2026-08-25 23:15:00+00	2026-08-21 11:47:09.172994+00
302	pay_sim_0301	synthetic	196100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_006	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	196100	196100	2026-08-24 12:01:00+00	2026-08-21 11:47:09.172994+00
310	pay_sim_0309	synthetic	388400	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_028	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	388400	388400	2026-08-12 09:39:00+00	2026-08-21 11:47:09.172994+00
312	pay_sim_0311	synthetic	28600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_071	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	28600	2026-08-24 16:34:00+00	2026-08-21 11:47:09.172994+00
313	pay_sim_0312	synthetic	426300	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_037	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	426300	426300	2026-08-27 21:51:00+00	2026-08-21 11:47:09.172994+00
376	pay_sim_0375	synthetic	251500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_022	merch_004	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	251500	251500	2026-08-05 13:20:00+00	2026-08-21 11:47:09.172994+00
73	pay_sim_0072	synthetic	170300	INR	card	CARD_EXPIRED	Card on file expired	cust_051	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	170300	0	2026-08-04 22:05:00+00	2026-08-21 11:47:09.172994+00
378	pay_sim_0377	synthetic	174700	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_063	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	174700	174700	2026-08-27 20:35:00+00	2026-08-21 11:47:09.172994+00
390	pay_sim_0389	synthetic	456200	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_036	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	456200	456200	2026-08-06 18:45:00+00	2026-08-21 11:47:09.172994+00
410	pay_sim_0409	synthetic	271500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_014	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	271500	271500	2026-08-12 17:08:00+00	2026-08-21 11:47:09.172994+00
413	pay_sim_0412	synthetic	377300	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_053	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	377300	377300	2026-08-28 14:05:00+00	2026-08-21 11:47:09.172994+00
490	pay_sim_0489	synthetic	484100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_023	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	484100	484100	2026-08-13 09:11:00+00	2026-08-21 11:47:09.172994+00
10	pay_sim_0009	synthetic	232500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_029	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	232500	232500	2026-08-27 12:04:00+00	2026-08-21 11:47:09.172994+00
12	pay_sim_0011	synthetic	344600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_016	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	344600	2026-08-26 16:32:00+00	2026-08-21 11:47:09.172994+00
13	pay_sim_0012	synthetic	373500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_070	merch_004	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	373500	373500	2026-08-03 09:56:00+00	2026-08-21 11:47:09.172994+00
86	pay_sim_0085	synthetic	494400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_017	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	494400	494400	2026-08-18 18:24:00+00	2026-08-21 11:47:09.172994+00
90	pay_sim_0089	synthetic	364500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_013	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	364500	364500	2026-08-11 16:23:00+00	2026-08-21 11:47:09.172994+00
102	pay_sim_0101	synthetic	323000	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_068	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	323000	323000	2026-08-14 22:21:00+00	2026-08-21 11:47:09.172994+00
185	pay_sim_0184	synthetic	111300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_067	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	111300	2026-08-28 16:49:00+00	2026-08-21 11:47:09.172994+00
212	pay_sim_0211	synthetic	357400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_038	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	357400	2026-08-28 15:55:00+00	2026-08-21 11:47:09.172994+00
213	pay_sim_0212	synthetic	488100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_021	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	488100	488100	2026-08-24 18:12:00+00	2026-08-21 11:47:09.172994+00
469	pay_sim_0468	synthetic	64800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_053	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	64800	2026-08-27 10:17:00+00	2026-08-21 11:47:09.172994+00
37	pay_sim_0036	synthetic	139500	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_049	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	139500	139500	2026-08-16 09:08:00+00	2026-08-21 11:47:09.172994+00
121	pay_sim_0120	synthetic	176500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_014	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	176500	2026-08-26 13:38:00+00	2026-08-21 11:47:09.172994+00
216	pay_sim_0215	synthetic	303900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_028	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	303900	303900	2026-08-02 09:18:00+00	2026-08-21 11:47:09.172994+00
217	pay_sim_0216	synthetic	400400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_064	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	400400	400400	2026-08-10 08:54:00+00	2026-08-21 11:47:09.172994+00
219	pay_sim_0218	synthetic	51900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_052	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	51900	51900	2026-08-13 09:36:00+00	2026-08-21 11:47:09.172994+00
225	pay_sim_0224	synthetic	389200	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_061	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	389200	389200	2026-08-05 12:20:00+00	2026-08-21 11:47:09.172994+00
231	pay_sim_0230	synthetic	408400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_007	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	408400	408400	2026-08-06 20:09:00+00	2026-08-21 11:47:09.172994+00
278	pay_sim_0277	synthetic	33500	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_029	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	33500	33500	2026-08-10 22:43:00+00	2026-08-21 11:47:09.172994+00
286	pay_sim_0285	synthetic	195900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_019	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	195900	195900	2026-08-14 17:17:00+00	2026-08-21 11:47:09.172994+00
287	pay_sim_0286	synthetic	499500	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_008	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	499500	499500	2026-08-24 13:40:00+00	2026-08-21 11:47:09.172994+00
425	pay_sim_0424	synthetic	79600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_011	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	79600	79600	2026-08-17 14:51:00+00	2026-08-21 11:47:09.172994+00
496	pay_sim_0495	synthetic	331000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_001	merch_001	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	331000	331000	2026-08-15 21:10:00+00	2026-08-21 11:47:09.172994+00
140	pay_sim_0139	synthetic	97700	INR	card	CARD_EXPIRED	Card on file expired	cust_010	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	97700	0	2026-08-17 09:42:00+00	2026-08-21 11:47:09.172994+00
44	pay_sim_0043	synthetic	95500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_012	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	recovered	95500	95500	2026-08-25 11:28:00+00	2026-08-21 11:47:09.172994+00
45	pay_sim_0044	synthetic	38600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_022	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	recovered	38600	38600	2026-08-02 18:50:00+00	2026-08-21 11:47:09.172994+00
158	pay_sim_0157	synthetic	66300	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_080	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	66300	0	2026-08-04 23:38:00+00	2026-08-21 11:47:09.172994+00
240	pay_sim_0239	synthetic	114700	INR	card	CARD_EXPIRED	Card on file expired	cust_036	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	114700	0	2026-08-19 20:57:00+00	2026-08-21 11:47:09.172994+00
283	pay_sim_0282	synthetic	51100	INR	card	CARD_EXPIRED	Card on file expired	cust_007	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	51100	0	2026-08-13 22:14:00+00	2026-08-21 11:47:09.172994+00
284	pay_sim_0283	synthetic	61100	INR	card	CARD_EXPIRED	Card on file expired	cust_070	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	61100	0	2026-08-05 17:14:00+00	2026-08-21 11:47:09.172994+00
440	pay_sim_0439	synthetic	52500	INR	card	CARD_EXPIRED	Card on file expired	cust_029	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	52500	0	2026-08-13 10:56:00+00	2026-08-21 11:47:09.172994+00
4	pay_sim_0003	synthetic	96100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_080	merch_001	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	96100	96100	2026-08-25 14:40:00+00	2026-08-21 11:47:09.172994+00
1	pay_sim_0000	synthetic	111900	INR	card	CARD_EXPIRED	Card on file expired	cust_011	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	111900	0	2026-08-18 21:38:00+00	2026-08-21 11:47:09.172994+00
3	pay_sim_0002	synthetic	497000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_057	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	497000	0	2026-08-14 17:36:00+00	2026-08-21 11:47:09.172994+00
5	pay_sim_0004	synthetic	81400	INR	card	CARD_EXPIRED	Card on file expired	cust_028	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	81400	0	2026-08-06 15:11:00+00	2026-08-21 11:47:09.172994+00
6	pay_sim_0005	synthetic	143100	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_071	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	143100	2026-08-01 21:28:00+00	2026-08-21 11:47:09.172994+00
7	pay_sim_0006	synthetic	253400	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_077	merch_004	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	253400	0	2026-08-02 15:18:00+00	2026-08-21 11:47:09.172994+00
8	pay_sim_0007	synthetic	73200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_037	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	73200	2026-08-22 15:59:00+00	2026-08-21 11:47:09.172994+00
9	pay_sim_0008	synthetic	176900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_034	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	176900	2026-08-14 11:34:00+00	2026-08-21 11:47:09.172994+00
11	pay_sim_0010	synthetic	481100	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_008	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	481100	2026-08-26 17:28:00+00	2026-08-21 11:47:09.172994+00
14	pay_sim_0013	synthetic	220000	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_056	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	220000	0	2026-08-01 10:14:00+00	2026-08-21 11:47:09.172994+00
15	pay_sim_0014	synthetic	235600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_074	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	235600	2026-08-19 09:48:00+00	2026-08-21 11:47:09.172994+00
18	pay_sim_0017	synthetic	349400	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_061	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	349400	0	2026-08-11 18:42:00+00	2026-08-21 11:47:09.172994+00
20	pay_sim_0019	synthetic	387400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_052	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	387400	2026-08-03 18:16:00+00	2026-08-21 11:47:09.172994+00
21	pay_sim_0020	synthetic	436400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_042	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	436400	2026-08-27 08:42:00+00	2026-08-21 11:47:09.172994+00
22	pay_sim_0021	synthetic	353400	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_070	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	353400	2026-08-02 14:33:00+00	2026-08-21 11:47:09.172994+00
23	pay_sim_0022	synthetic	423200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_047	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	423200	0	2026-08-21 22:48:00+00	2026-08-21 11:47:09.172994+00
24	pay_sim_0023	synthetic	233600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_007	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	233600	0	2026-08-18 12:59:00+00	2026-08-21 11:47:09.172994+00
26	pay_sim_0025	synthetic	269400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_078	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	269400	2026-08-18 08:35:00+00	2026-08-21 11:47:09.172994+00
27	pay_sim_0026	synthetic	198900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_053	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	198900	0	2026-08-27 11:29:00+00	2026-08-21 11:47:09.172994+00
28	pay_sim_0027	synthetic	423100	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_016	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	423100	0	2026-08-23 17:32:00+00	2026-08-21 11:47:09.172994+00
29	pay_sim_0028	synthetic	410100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_035	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	410100	0	2026-08-16 15:29:00+00	2026-08-21 11:47:09.172994+00
30	pay_sim_0029	synthetic	329100	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_071	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	329100	2026-08-07 12:55:00+00	2026-08-21 11:47:09.172994+00
2	pay_sim_0001	synthetic	199700	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_077	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	199700	199700	2026-08-25 20:28:00+00	2026-08-21 11:47:09.172994+00
25	pay_sim_0024	synthetic	411900	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_037	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	411900	411900	2026-08-04 08:40:00+00	2026-08-21 11:47:09.172994+00
32	pay_sim_0031	synthetic	495700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_001	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	495700	2026-08-19 23:55:00+00	2026-08-21 11:47:09.172994+00
33	pay_sim_0032	synthetic	411600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_020	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	411600	2026-08-28 19:21:00+00	2026-08-21 11:47:09.172994+00
34	pay_sim_0033	synthetic	323900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_071	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	323900	0	2026-08-15 18:55:00+00	2026-08-21 11:47:09.172994+00
35	pay_sim_0034	synthetic	483300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_025	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	483300	0	2026-08-13 15:54:00+00	2026-08-21 11:47:09.172994+00
36	pay_sim_0035	synthetic	275500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_053	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	275500	0	2026-08-24 23:45:00+00	2026-08-21 11:47:09.172994+00
38	pay_sim_0037	synthetic	286800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_065	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	286800	0	2026-08-28 11:55:00+00	2026-08-21 11:47:09.172994+00
40	pay_sim_0039	synthetic	141300	INR	card	CARD_EXPIRED	Card on file expired	cust_019	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	141300	0	2026-08-03 23:50:00+00	2026-08-21 11:47:09.172994+00
41	pay_sim_0040	synthetic	340500	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_034	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	340500	0	2026-08-21 10:54:00+00	2026-08-21 11:47:09.172994+00
42	pay_sim_0041	synthetic	326200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_043	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	326200	0	2026-08-11 23:55:00+00	2026-08-21 11:47:09.172994+00
43	pay_sim_0042	synthetic	70900	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_070	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	70900	0	2026-08-08 17:14:00+00	2026-08-21 11:47:09.172994+00
46	pay_sim_0045	synthetic	321900	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_008	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	321900	2026-08-14 12:15:00+00	2026-08-21 11:47:09.172994+00
47	pay_sim_0046	synthetic	478500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_068	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	478500	0	2026-08-22 13:10:00+00	2026-08-21 11:47:09.172994+00
48	pay_sim_0047	synthetic	328200	INR	card	CARD_EXPIRED	Card on file expired	cust_023	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	328200	0	2026-08-20 15:31:00+00	2026-08-21 11:47:09.172994+00
49	pay_sim_0048	synthetic	392600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_075	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	392600	2026-08-25 16:29:00+00	2026-08-21 11:47:09.172994+00
50	pay_sim_0049	synthetic	396000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_033	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	396000	0	2026-08-10 13:04:00+00	2026-08-21 11:47:09.172994+00
51	pay_sim_0050	synthetic	259900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	259900	2026-08-28 21:44:00+00	2026-08-21 11:47:09.172994+00
52	pay_sim_0051	synthetic	178000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_033	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	178000	2026-08-13 23:06:00+00	2026-08-21 11:47:09.172994+00
53	pay_sim_0052	synthetic	483400	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_031	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	483400	2026-08-12 17:44:00+00	2026-08-21 11:47:09.172994+00
54	pay_sim_0053	synthetic	339100	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_038	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	339100	0	2026-08-09 08:36:00+00	2026-08-21 11:47:09.172994+00
55	pay_sim_0054	synthetic	249300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_007	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	249300	2026-08-27 15:38:00+00	2026-08-21 11:47:09.172994+00
56	pay_sim_0055	synthetic	220200	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_046	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	220200	2026-08-22 12:40:00+00	2026-08-21 11:47:09.172994+00
57	pay_sim_0056	synthetic	376000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_013	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	376000	2026-08-02 19:46:00+00	2026-08-21 11:47:09.172994+00
58	pay_sim_0057	synthetic	256600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_017	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	256600	0	2026-08-11 21:11:00+00	2026-08-21 11:47:09.172994+00
59	pay_sim_0058	synthetic	456700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_026	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	456700	0	2026-08-12 16:53:00+00	2026-08-21 11:47:09.172994+00
60	pay_sim_0059	synthetic	409600	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_022	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	409600	0	2026-08-26 17:47:00+00	2026-08-21 11:47:09.172994+00
61	pay_sim_0060	synthetic	398500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_044	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	398500	0	2026-08-03 12:48:00+00	2026-08-21 11:47:09.172994+00
39	pay_sim_0038	synthetic	389200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	389200	2026-08-28 08:46:00+00	2026-08-21 11:47:09.172994+00
31	pay_sim_0030	synthetic	354800	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_009	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	354800	354800	2026-08-11 16:52:00+00	2026-08-21 11:47:09.172994+00
62	pay_sim_0061	synthetic	471400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_029	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	471400	0	2026-08-12 10:50:00+00	2026-08-21 11:47:09.172994+00
63	pay_sim_0062	synthetic	231500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_051	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	231500	0	2026-08-18 11:29:00+00	2026-08-21 11:47:09.172994+00
64	pay_sim_0063	synthetic	319200	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_048	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	319200	2026-08-04 15:30:00+00	2026-08-21 11:47:09.172994+00
65	pay_sim_0064	synthetic	474800	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_004	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	474800	2026-08-11 15:41:00+00	2026-08-21 11:47:09.172994+00
66	pay_sim_0065	synthetic	349300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_009	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	349300	2026-08-26 11:08:00+00	2026-08-21 11:47:09.172994+00
67	pay_sim_0066	synthetic	264200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_006	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	264200	0	2026-08-16 11:06:00+00	2026-08-21 11:47:09.172994+00
68	pay_sim_0067	synthetic	126000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_031	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	126000	0	2026-08-13 22:23:00+00	2026-08-21 11:47:09.172994+00
69	pay_sim_0068	synthetic	141400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_070	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	141400	2026-08-28 21:41:00+00	2026-08-21 11:47:09.172994+00
70	pay_sim_0069	synthetic	349200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_013	merch_004	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	349200	0	2026-08-09 09:44:00+00	2026-08-21 11:47:09.172994+00
71	pay_sim_0070	synthetic	378100	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_048	merch_002	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	378100	2026-08-15 15:54:00+00	2026-08-21 11:47:09.172994+00
72	pay_sim_0071	synthetic	315800	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_047	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	315800	2026-08-18 19:03:00+00	2026-08-21 11:47:09.172994+00
74	pay_sim_0073	synthetic	32300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_028	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	32300	0	2026-08-02 18:15:00+00	2026-08-21 11:47:09.172994+00
75	pay_sim_0074	synthetic	183000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_017	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	183000	2026-08-03 14:37:00+00	2026-08-21 11:47:09.172994+00
76	pay_sim_0075	synthetic	284000	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_028	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	284000	0	2026-08-25 12:50:00+00	2026-08-21 11:47:09.172994+00
77	pay_sim_0076	synthetic	242000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_077	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	242000	0	2026-08-28 12:08:00+00	2026-08-21 11:47:09.172994+00
79	pay_sim_0078	synthetic	209800	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_002	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	209800	2026-08-19 18:01:00+00	2026-08-21 11:47:09.172994+00
80	pay_sim_0079	synthetic	57800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_023	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	57800	0	2026-08-05 21:33:00+00	2026-08-21 11:47:09.172994+00
81	pay_sim_0080	synthetic	405000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_015	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	405000	0	2026-08-15 19:32:00+00	2026-08-21 11:47:09.172994+00
82	pay_sim_0081	synthetic	427600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_076	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	427600	2026-08-27 15:39:00+00	2026-08-21 11:47:09.172994+00
83	pay_sim_0082	synthetic	261900	INR	card	CARD_EXPIRED	Card on file expired	cust_006	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	261900	0	2026-08-15 08:03:00+00	2026-08-21 11:47:09.172994+00
84	pay_sim_0083	synthetic	364100	INR	card	CARD_EXPIRED	Card on file expired	cust_062	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	364100	0	2026-08-22 11:31:00+00	2026-08-21 11:47:09.172994+00
85	pay_sim_0084	synthetic	278700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	278700	2026-08-24 12:04:00+00	2026-08-21 11:47:09.172994+00
88	pay_sim_0087	synthetic	367200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_015	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	367200	2026-08-25 22:56:00+00	2026-08-21 11:47:09.172994+00
89	pay_sim_0088	synthetic	386400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_030	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	386400	2026-08-26 20:26:00+00	2026-08-21 11:47:09.172994+00
91	pay_sim_0090	synthetic	69800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_020	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	69800	0	2026-08-03 10:05:00+00	2026-08-21 11:47:09.172994+00
92	pay_sim_0091	synthetic	320100	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_056	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	320100	0	2026-08-26 12:35:00+00	2026-08-21 11:47:09.172994+00
93	pay_sim_0092	synthetic	474900	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_008	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	474900	2026-08-18 18:42:00+00	2026-08-21 11:47:09.172994+00
87	pay_sim_0086	synthetic	256400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_077	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	256400	256400	2026-08-15 21:06:00+00	2026-08-21 11:47:09.172994+00
78	pay_sim_0077	synthetic	157800	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_070	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	157800	157800	2026-08-04 08:08:00+00	2026-08-21 11:47:09.172994+00
94	pay_sim_0093	synthetic	304500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_016	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	304500	0	2026-08-28 21:55:00+00	2026-08-21 11:47:09.172994+00
95	pay_sim_0094	synthetic	270800	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_007	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	270800	2026-08-12 11:36:00+00	2026-08-21 11:47:09.172994+00
97	pay_sim_0096	synthetic	470500	INR	card	CARD_EXPIRED	Card on file expired	cust_014	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	470500	0	2026-08-12 11:48:00+00	2026-08-21 11:47:09.172994+00
98	pay_sim_0097	synthetic	366400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_036	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	366400	2026-08-28 08:38:00+00	2026-08-21 11:47:09.172994+00
99	pay_sim_0098	synthetic	162600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_035	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	162600	2026-08-09 17:58:00+00	2026-08-21 11:47:09.172994+00
100	pay_sim_0099	synthetic	19900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_044	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	19900	0	2026-08-06 12:36:00+00	2026-08-21 11:47:09.172994+00
101	pay_sim_0100	synthetic	131100	INR	card	CARD_EXPIRED	Card on file expired	cust_052	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	131100	0	2026-08-24 08:05:00+00	2026-08-21 11:47:09.172994+00
103	pay_sim_0102	synthetic	270100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_021	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	270100	0	2026-08-24 18:49:00+00	2026-08-21 11:47:09.172994+00
104	pay_sim_0103	synthetic	84400	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_073	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	84400	2026-08-02 12:10:00+00	2026-08-21 11:47:09.172994+00
105	pay_sim_0104	synthetic	81700	INR	card	CARD_EXPIRED	Card on file expired	cust_080	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	81700	0	2026-08-09 22:42:00+00	2026-08-21 11:47:09.172994+00
106	pay_sim_0105	synthetic	377000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_055	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	377000	2026-08-14 16:13:00+00	2026-08-21 11:47:09.172994+00
107	pay_sim_0106	synthetic	297600	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_066	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	297600	0	2026-08-14 11:18:00+00	2026-08-21 11:47:09.172994+00
108	pay_sim_0107	synthetic	446500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_076	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	446500	2026-08-22 17:02:00+00	2026-08-21 11:47:09.172994+00
111	pay_sim_0110	synthetic	158800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_001	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	158800	2026-08-27 12:24:00+00	2026-08-21 11:47:09.172994+00
114	pay_sim_0113	synthetic	486500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_010	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	486500	0	2026-08-14 20:45:00+00	2026-08-21 11:47:09.172994+00
115	pay_sim_0114	synthetic	346700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_054	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	346700	2026-08-01 18:10:00+00	2026-08-21 11:47:09.172994+00
118	pay_sim_0117	synthetic	269000	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_011	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	269000	0	2026-08-24 18:14:00+00	2026-08-21 11:47:09.172994+00
120	pay_sim_0119	synthetic	302500	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_066	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	302500	2026-08-24 12:15:00+00	2026-08-21 11:47:09.172994+00
122	pay_sim_0121	synthetic	160000	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_020	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	160000	2026-08-25 23:29:00+00	2026-08-21 11:47:09.172994+00
123	pay_sim_0122	synthetic	382600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_073	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	382600	0	2026-08-22 18:55:00+00	2026-08-21 11:47:09.172994+00
124	pay_sim_0123	synthetic	375100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_041	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	375100	0	2026-08-03 23:28:00+00	2026-08-21 11:47:09.172994+00
110	pay_sim_0109	synthetic	224200	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_028	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	224200	224200	2026-08-10 18:07:00+00	2026-08-21 11:47:09.172994+00
113	pay_sim_0112	synthetic	372200	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_051	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	372200	372200	2026-08-01 22:58:00+00	2026-08-21 11:47:09.172994+00
109	pay_sim_0108	synthetic	59700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_029	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	59700	59700	2026-08-01 14:19:00+00	2026-08-21 11:47:09.172994+00
112	pay_sim_0111	synthetic	472600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_069	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	472600	2026-08-28 19:04:00+00	2026-08-21 11:47:09.172994+00
96	pay_sim_0095	synthetic	141600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_065	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	141600	141600	2026-08-22 23:14:00+00	2026-08-21 11:47:09.172994+00
126	pay_sim_0125	synthetic	385100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_010	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	385100	2026-08-02 09:23:00+00	2026-08-21 11:47:09.172994+00
127	pay_sim_0126	synthetic	88800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_037	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	88800	0	2026-08-20 20:29:00+00	2026-08-21 11:47:09.172994+00
128	pay_sim_0127	synthetic	48500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_075	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	48500	0	2026-08-15 14:20:00+00	2026-08-21 11:47:09.172994+00
129	pay_sim_0128	synthetic	425600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_078	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	425600	0	2026-08-05 09:28:00+00	2026-08-21 11:47:09.172994+00
130	pay_sim_0129	synthetic	83900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_014	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	83900	2026-08-17 13:02:00+00	2026-08-21 11:47:09.172994+00
132	pay_sim_0131	synthetic	349700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_048	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	349700	2026-08-25 18:43:00+00	2026-08-21 11:47:09.172994+00
133	pay_sim_0132	synthetic	68800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_077	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	68800	2026-08-26 18:06:00+00	2026-08-21 11:47:09.172994+00
134	pay_sim_0133	synthetic	247600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_072	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	247600	0	2026-08-09 12:21:00+00	2026-08-21 11:47:09.172994+00
135	pay_sim_0134	synthetic	130700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_011	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	130700	0	2026-08-12 17:41:00+00	2026-08-21 11:47:09.172994+00
136	pay_sim_0135	synthetic	84300	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_051	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	84300	0	2026-08-10 20:41:00+00	2026-08-21 11:47:09.172994+00
138	pay_sim_0137	synthetic	311900	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_047	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	311900	0	2026-08-10 13:13:00+00	2026-08-21 11:47:09.172994+00
139	pay_sim_0138	synthetic	200400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_044	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	200400	2026-08-25 12:09:00+00	2026-08-21 11:47:09.172994+00
141	pay_sim_0140	synthetic	122200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_044	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	122200	0	2026-08-20 20:09:00+00	2026-08-21 11:47:09.172994+00
142	pay_sim_0141	synthetic	150500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_021	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	150500	0	2026-08-24 22:02:00+00	2026-08-21 11:47:09.172994+00
143	pay_sim_0142	synthetic	209400	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_053	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	209400	0	2026-08-15 17:48:00+00	2026-08-21 11:47:09.172994+00
144	pay_sim_0143	synthetic	452300	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_058	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	452300	2026-08-08 17:51:00+00	2026-08-21 11:47:09.172994+00
145	pay_sim_0144	synthetic	316200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_061	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	316200	2026-08-22 22:29:00+00	2026-08-21 11:47:09.172994+00
146	pay_sim_0145	synthetic	147600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_037	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	147600	2026-08-27 14:51:00+00	2026-08-21 11:47:09.172994+00
147	pay_sim_0146	synthetic	219700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_078	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	219700	0	2026-08-02 23:55:00+00	2026-08-21 11:47:09.172994+00
148	pay_sim_0147	synthetic	98900	INR	card	CARD_EXPIRED	Card on file expired	cust_048	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	98900	0	2026-08-23 11:18:00+00	2026-08-21 11:47:09.172994+00
149	pay_sim_0148	synthetic	382900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_011	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	382900	2026-08-26 12:53:00+00	2026-08-21 11:47:09.172994+00
150	pay_sim_0149	synthetic	196700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_056	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	196700	0	2026-08-27 22:56:00+00	2026-08-21 11:47:09.172994+00
151	pay_sim_0150	synthetic	58500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_045	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	58500	2026-08-27 20:32:00+00	2026-08-21 11:47:09.172994+00
152	pay_sim_0151	synthetic	81700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_048	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	81700	2026-08-12 15:01:00+00	2026-08-21 11:47:09.172994+00
153	pay_sim_0152	synthetic	289500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_041	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	289500	2026-08-26 12:08:00+00	2026-08-21 11:47:09.172994+00
154	pay_sim_0153	synthetic	401900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_005	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	401900	0	2026-08-23 12:48:00+00	2026-08-21 11:47:09.172994+00
155	pay_sim_0154	synthetic	19200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_061	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	19200	2026-08-28 10:01:00+00	2026-08-21 11:47:09.172994+00
156	pay_sim_0155	synthetic	464400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_033	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	464400	2026-08-24 21:07:00+00	2026-08-21 11:47:09.172994+00
157	pay_sim_0156	synthetic	114700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_037	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	114700	2026-08-02 15:26:00+00	2026-08-21 11:47:09.172994+00
159	pay_sim_0158	synthetic	437000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_069	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	437000	0	2026-08-19 15:45:00+00	2026-08-21 11:47:09.172994+00
160	pay_sim_0159	synthetic	366500	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_019	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	366500	0	2026-08-01 19:15:00+00	2026-08-21 11:47:09.172994+00
161	pay_sim_0160	synthetic	168300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_074	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	168300	0	2026-08-22 10:33:00+00	2026-08-21 11:47:09.172994+00
162	pay_sim_0161	synthetic	445800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_047	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	445800	0	2026-08-18 08:24:00+00	2026-08-21 11:47:09.172994+00
163	pay_sim_0162	synthetic	331800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_061	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	331800	0	2026-08-12 16:47:00+00	2026-08-21 11:47:09.172994+00
164	pay_sim_0163	synthetic	297300	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_003	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	297300	2026-08-08 11:49:00+00	2026-08-21 11:47:09.172994+00
165	pay_sim_0164	synthetic	124100	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_075	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	124100	2026-08-02 19:34:00+00	2026-08-21 11:47:09.172994+00
166	pay_sim_0165	synthetic	406900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_044	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	406900	2026-08-27 13:51:00+00	2026-08-21 11:47:09.172994+00
167	pay_sim_0166	synthetic	389800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_018	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	389800	0	2026-08-02 17:12:00+00	2026-08-21 11:47:09.172994+00
168	pay_sim_0167	synthetic	49200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_006	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	49200	0	2026-08-11 17:32:00+00	2026-08-21 11:47:09.172994+00
169	pay_sim_0168	synthetic	222400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_051	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	222400	2026-08-27 09:48:00+00	2026-08-21 11:47:09.172994+00
170	pay_sim_0169	synthetic	307300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_025	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	307300	0	2026-08-28 09:55:00+00	2026-08-21 11:47:09.172994+00
171	pay_sim_0170	synthetic	116800	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_043	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	116800	2026-08-26 19:27:00+00	2026-08-21 11:47:09.172994+00
172	pay_sim_0171	synthetic	331600	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_052	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	331600	2026-08-11 13:31:00+00	2026-08-21 11:47:09.172994+00
173	pay_sim_0172	synthetic	440200	INR	card	CARD_EXPIRED	Card on file expired	cust_064	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	440200	0	2026-08-09 10:46:00+00	2026-08-21 11:47:09.172994+00
174	pay_sim_0173	synthetic	367600	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_055	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	367600	0	2026-08-20 13:34:00+00	2026-08-21 11:47:09.172994+00
175	pay_sim_0174	synthetic	98900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_038	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	98900	2026-08-03 18:42:00+00	2026-08-21 11:47:09.172994+00
176	pay_sim_0175	synthetic	380100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_038	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	380100	0	2026-08-20 21:10:00+00	2026-08-21 11:47:09.172994+00
177	pay_sim_0176	synthetic	381100	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_057	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	381100	0	2026-08-02 19:39:00+00	2026-08-21 11:47:09.172994+00
179	pay_sim_0178	synthetic	40400	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_066	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	40400	2026-08-05 22:02:00+00	2026-08-21 11:47:09.172994+00
180	pay_sim_0179	synthetic	208200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_017	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	208200	0	2026-08-25 19:23:00+00	2026-08-21 11:47:09.172994+00
181	pay_sim_0180	synthetic	41400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_050	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	41400	0	2026-08-20 12:43:00+00	2026-08-21 11:47:09.172994+00
182	pay_sim_0181	synthetic	378500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_058	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	378500	2026-08-26 10:36:00+00	2026-08-21 11:47:09.172994+00
183	pay_sim_0182	synthetic	315500	INR	card	CARD_EXPIRED	Card on file expired	cust_018	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	315500	0	2026-08-13 18:41:00+00	2026-08-21 11:47:09.172994+00
184	pay_sim_0183	synthetic	107800	INR	card	CARD_EXPIRED	Card on file expired	cust_036	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	107800	0	2026-08-01 13:31:00+00	2026-08-21 11:47:09.172994+00
186	pay_sim_0185	synthetic	190600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_034	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	190600	2026-08-20 17:44:00+00	2026-08-21 11:47:09.172994+00
188	pay_sim_0187	synthetic	276700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_023	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	276700	2026-08-24 19:45:00+00	2026-08-21 11:47:09.172994+00
189	pay_sim_0188	synthetic	252700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_009	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	252700	2026-08-28 17:54:00+00	2026-08-21 11:47:09.172994+00
190	pay_sim_0189	synthetic	311000	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_021	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	311000	0	2026-08-17 15:07:00+00	2026-08-21 11:47:09.172994+00
191	pay_sim_0190	synthetic	208800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_026	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	208800	0	2026-08-26 23:01:00+00	2026-08-21 11:47:09.172994+00
192	pay_sim_0191	synthetic	483700	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_047	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	483700	0	2026-08-12 22:51:00+00	2026-08-21 11:47:09.172994+00
193	pay_sim_0192	synthetic	85500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_071	merch_002	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	85500	2026-08-03 17:25:00+00	2026-08-21 11:47:09.172994+00
194	pay_sim_0193	synthetic	351400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_062	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	351400	0	2026-08-25 21:52:00+00	2026-08-21 11:47:09.172994+00
195	pay_sim_0194	synthetic	117500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_074	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	117500	2026-08-11 10:28:00+00	2026-08-21 11:47:09.172994+00
197	pay_sim_0196	synthetic	426800	INR	card	CARD_EXPIRED	Card on file expired	cust_017	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	426800	0	2026-08-28 09:53:00+00	2026-08-21 11:47:09.172994+00
198	pay_sim_0197	synthetic	264000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_016	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	264000	2026-08-06 13:20:00+00	2026-08-21 11:47:09.172994+00
199	pay_sim_0198	synthetic	439900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_029	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	439900	2026-08-10 10:16:00+00	2026-08-21 11:47:09.172994+00
200	pay_sim_0199	synthetic	239700	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_026	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	239700	0	2026-08-05 17:39:00+00	2026-08-21 11:47:09.172994+00
201	pay_sim_0200	synthetic	426600	INR	card	CARD_EXPIRED	Card on file expired	cust_069	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	426600	0	2026-08-21 13:37:00+00	2026-08-21 11:47:09.172994+00
203	pay_sim_0202	synthetic	38100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_073	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	38100	0	2026-08-03 09:41:00+00	2026-08-21 11:47:09.172994+00
205	pay_sim_0204	synthetic	461800	INR	card	CARD_EXPIRED	Card on file expired	cust_004	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	461800	0	2026-08-10 17:30:00+00	2026-08-21 11:47:09.172994+00
206	pay_sim_0205	synthetic	258500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_032	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	258500	2026-08-15 10:44:00+00	2026-08-21 11:47:09.172994+00
207	pay_sim_0206	synthetic	375000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_008	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	375000	0	2026-08-14 23:29:00+00	2026-08-21 11:47:09.172994+00
208	pay_sim_0207	synthetic	132500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_027	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	132500	2026-08-11 18:46:00+00	2026-08-21 11:47:09.172994+00
209	pay_sim_0208	synthetic	122000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_045	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	122000	2026-08-25 19:32:00+00	2026-08-21 11:47:09.172994+00
211	pay_sim_0210	synthetic	130300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_035	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	130300	2026-08-25 11:03:00+00	2026-08-21 11:47:09.172994+00
214	pay_sim_0213	synthetic	436500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_021	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	436500	0	2026-08-15 23:56:00+00	2026-08-21 11:47:09.172994+00
215	pay_sim_0214	synthetic	88600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_040	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	88600	2026-08-13 22:15:00+00	2026-08-21 11:47:09.172994+00
218	pay_sim_0217	synthetic	124600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_014	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	124600	0	2026-08-09 19:48:00+00	2026-08-21 11:47:09.172994+00
202	pay_sim_0201	synthetic	155100	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_075	merch_002	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	155100	155100	2026-08-22 18:53:00+00	2026-08-21 11:47:09.172994+00
220	pay_sim_0219	synthetic	468100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_072	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	468100	2026-08-10 10:24:00+00	2026-08-21 11:47:09.172994+00
221	pay_sim_0220	synthetic	244000	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_065	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	244000	2026-08-28 11:08:00+00	2026-08-21 11:47:09.172994+00
222	pay_sim_0221	synthetic	320600	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_013	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	320600	2026-08-26 18:35:00+00	2026-08-21 11:47:09.172994+00
223	pay_sim_0222	synthetic	177900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_047	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	177900	0	2026-08-20 20:32:00+00	2026-08-21 11:47:09.172994+00
224	pay_sim_0223	synthetic	46700	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_006	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	46700	0	2026-08-05 18:51:00+00	2026-08-21 11:47:09.172994+00
226	pay_sim_0225	synthetic	336800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_079	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	336800	2026-08-20 17:37:00+00	2026-08-21 11:47:09.172994+00
227	pay_sim_0226	synthetic	432400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_044	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	432400	0	2026-08-18 23:45:00+00	2026-08-21 11:47:09.172994+00
228	pay_sim_0227	synthetic	403900	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_073	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	403900	0	2026-08-27 08:23:00+00	2026-08-21 11:47:09.172994+00
229	pay_sim_0228	synthetic	356100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_043	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	356100	0	2026-08-19 17:50:00+00	2026-08-21 11:47:09.172994+00
230	pay_sim_0229	synthetic	403600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_004	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	403600	2026-08-09 15:46:00+00	2026-08-21 11:47:09.172994+00
232	pay_sim_0231	synthetic	171100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_032	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	171100	2026-08-01 22:20:00+00	2026-08-21 11:47:09.172994+00
233	pay_sim_0232	synthetic	181900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_054	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	181900	2026-08-27 21:32:00+00	2026-08-21 11:47:09.172994+00
234	pay_sim_0233	synthetic	65900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_079	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	65900	0	2026-08-23 12:33:00+00	2026-08-21 11:47:09.172994+00
235	pay_sim_0234	synthetic	281100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_027	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	281100	0	2026-08-22 23:33:00+00	2026-08-21 11:47:09.172994+00
236	pay_sim_0235	synthetic	156700	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_049	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	156700	0	2026-08-15 18:34:00+00	2026-08-21 11:47:09.172994+00
238	pay_sim_0237	synthetic	199100	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_072	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	199100	0	2026-08-10 17:45:00+00	2026-08-21 11:47:09.172994+00
239	pay_sim_0238	synthetic	407900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_027	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	407900	2026-08-26 19:35:00+00	2026-08-21 11:47:09.172994+00
241	pay_sim_0240	synthetic	134800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_051	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	134800	0	2026-08-10 09:18:00+00	2026-08-21 11:47:09.172994+00
242	pay_sim_0241	synthetic	377200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_011	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	377200	0	2026-08-21 16:47:00+00	2026-08-21 11:47:09.172994+00
243	pay_sim_0242	synthetic	180400	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_062	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	180400	0	2026-08-27 16:59:00+00	2026-08-21 11:47:09.172994+00
244	pay_sim_0243	synthetic	127300	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_072	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	127300	2026-08-04 15:15:00+00	2026-08-21 11:47:09.172994+00
245	pay_sim_0244	synthetic	199700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_007	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	199700	2026-08-21 15:03:00+00	2026-08-21 11:47:09.172994+00
246	pay_sim_0245	synthetic	401800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_013	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	401800	2026-08-04 12:00:00+00	2026-08-21 11:47:09.172994+00
247	pay_sim_0246	synthetic	348200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_071	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	348200	0	2026-08-21 23:30:00+00	2026-08-21 11:47:09.172994+00
248	pay_sim_0247	synthetic	278000	INR	card	CARD_EXPIRED	Card on file expired	cust_026	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	278000	0	2026-08-10 09:58:00+00	2026-08-21 11:47:09.172994+00
249	pay_sim_0248	synthetic	453200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_012	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	453200	2026-08-25 09:58:00+00	2026-08-21 11:47:09.172994+00
250	pay_sim_0249	synthetic	158900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_023	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	158900	0	2026-08-02 20:50:00+00	2026-08-21 11:47:09.172994+00
251	pay_sim_0250	synthetic	45500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_064	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	45500	2026-08-26 08:19:00+00	2026-08-21 11:47:09.172994+00
237	pay_sim_0236	synthetic	411500	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_046	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	411500	411500	2026-08-07 15:17:00+00	2026-08-21 11:47:09.172994+00
252	pay_sim_0251	synthetic	289300	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_073	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	289300	2026-08-10 22:41:00+00	2026-08-21 11:47:09.172994+00
253	pay_sim_0252	synthetic	419500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_070	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	419500	2026-08-05 22:17:00+00	2026-08-21 11:47:09.172994+00
254	pay_sim_0253	synthetic	285700	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_025	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	285700	0	2026-08-06 22:41:00+00	2026-08-21 11:47:09.172994+00
255	pay_sim_0254	synthetic	291000	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_033	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	291000	2026-08-24 17:36:00+00	2026-08-21 11:47:09.172994+00
256	pay_sim_0255	synthetic	365200	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_025	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	365200	2026-08-17 18:05:00+00	2026-08-21 11:47:09.172994+00
257	pay_sim_0256	synthetic	130000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_052	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	130000	2026-08-16 18:59:00+00	2026-08-21 11:47:09.172994+00
258	pay_sim_0257	synthetic	228500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_032	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	228500	0	2026-08-13 15:28:00+00	2026-08-21 11:47:09.172994+00
259	pay_sim_0258	synthetic	262200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_035	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	262200	0	2026-08-19 08:16:00+00	2026-08-21 11:47:09.172994+00
260	pay_sim_0259	synthetic	65700	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_047	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	65700	0	2026-08-22 11:29:00+00	2026-08-21 11:47:09.172994+00
261	pay_sim_0260	synthetic	347000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_040	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	347000	0	2026-08-22 17:44:00+00	2026-08-21 11:47:09.172994+00
262	pay_sim_0261	synthetic	315900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_016	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	315900	0	2026-08-20 15:14:00+00	2026-08-21 11:47:09.172994+00
263	pay_sim_0262	synthetic	140300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_018	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	140300	0	2026-08-15 19:26:00+00	2026-08-21 11:47:09.172994+00
264	pay_sim_0263	synthetic	217600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_071	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	217600	2026-08-22 10:33:00+00	2026-08-21 11:47:09.172994+00
265	pay_sim_0264	synthetic	311200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_058	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	311200	2026-08-03 11:03:00+00	2026-08-21 11:47:09.172994+00
266	pay_sim_0265	synthetic	484000	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_071	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	484000	2026-08-25 12:10:00+00	2026-08-21 11:47:09.172994+00
267	pay_sim_0266	synthetic	376800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_042	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	376800	0	2026-08-04 14:45:00+00	2026-08-21 11:47:09.172994+00
268	pay_sim_0267	synthetic	89300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_075	merch_004	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	89300	0	2026-08-17 22:51:00+00	2026-08-21 11:47:09.172994+00
270	pay_sim_0269	synthetic	472600	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_073	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	472600	0	2026-08-15 17:46:00+00	2026-08-21 11:47:09.172994+00
271	pay_sim_0270	synthetic	223300	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_003	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	223300	2026-08-27 08:47:00+00	2026-08-21 11:47:09.172994+00
272	pay_sim_0271	synthetic	74700	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_028	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	74700	2026-08-02 21:22:00+00	2026-08-21 11:47:09.172994+00
273	pay_sim_0272	synthetic	64200	INR	card	CARD_EXPIRED	Card on file expired	cust_009	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	64200	0	2026-08-03 23:02:00+00	2026-08-21 11:47:09.172994+00
274	pay_sim_0273	synthetic	162300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_037	merch_004	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	162300	0	2026-08-25 12:49:00+00	2026-08-21 11:47:09.172994+00
275	pay_sim_0274	synthetic	328200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_054	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	328200	2026-08-15 20:24:00+00	2026-08-21 11:47:09.172994+00
276	pay_sim_0275	synthetic	123800	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_011	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	123800	0	2026-08-21 19:07:00+00	2026-08-21 11:47:09.172994+00
277	pay_sim_0276	synthetic	336800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_023	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	336800	0	2026-08-17 12:46:00+00	2026-08-21 11:47:09.172994+00
279	pay_sim_0278	synthetic	450600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_070	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	450600	2026-08-13 15:15:00+00	2026-08-21 11:47:09.172994+00
280	pay_sim_0279	synthetic	141900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_059	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	141900	0	2026-08-09 14:59:00+00	2026-08-21 11:47:09.172994+00
281	pay_sim_0280	synthetic	358300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_015	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	358300	0	2026-08-20 08:15:00+00	2026-08-21 11:47:09.172994+00
282	pay_sim_0281	synthetic	42400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_027	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	42400	2026-08-24 22:38:00+00	2026-08-21 11:47:09.172994+00
269	pay_sim_0268	synthetic	435300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_008	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	435300	2026-08-25 21:29:00+00	2026-08-21 11:47:09.172994+00
285	pay_sim_0284	synthetic	277500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_074	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	277500	2026-08-28 15:19:00+00	2026-08-21 11:47:09.172994+00
288	pay_sim_0287	synthetic	53300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_055	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	53300	2026-08-27 19:41:00+00	2026-08-21 11:47:09.172994+00
289	pay_sim_0288	synthetic	355900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_049	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	355900	2026-08-26 21:09:00+00	2026-08-21 11:47:09.172994+00
291	pay_sim_0290	synthetic	133100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_029	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	133100	0	2026-08-26 22:58:00+00	2026-08-21 11:47:09.172994+00
292	pay_sim_0291	synthetic	352900	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_008	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	352900	0	2026-08-14 12:24:00+00	2026-08-21 11:47:09.172994+00
293	pay_sim_0292	synthetic	181400	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_032	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	181400	2026-08-11 10:59:00+00	2026-08-21 11:47:09.172994+00
294	pay_sim_0293	synthetic	90600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_058	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	90600	0	2026-08-18 14:03:00+00	2026-08-21 11:47:09.172994+00
295	pay_sim_0294	synthetic	47200	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_035	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	47200	2026-08-28 10:12:00+00	2026-08-21 11:47:09.172994+00
297	pay_sim_0296	synthetic	27400	INR	card	CARD_EXPIRED	Card on file expired	cust_043	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	27400	0	2026-08-07 14:47:00+00	2026-08-21 11:47:09.172994+00
298	pay_sim_0297	synthetic	182400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_016	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	182400	2026-08-13 15:35:00+00	2026-08-21 11:47:09.172994+00
299	pay_sim_0298	synthetic	326700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_042	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	326700	2026-08-15 19:19:00+00	2026-08-21 11:47:09.172994+00
300	pay_sim_0299	synthetic	434900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_034	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	434900	0	2026-08-16 22:06:00+00	2026-08-21 11:47:09.172994+00
301	pay_sim_0300	synthetic	181300	INR	card	CARD_EXPIRED	Card on file expired	cust_061	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	181300	0	2026-08-12 18:26:00+00	2026-08-21 11:47:09.172994+00
303	pay_sim_0302	synthetic	493300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_034	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	493300	0	2026-08-19 21:18:00+00	2026-08-21 11:47:09.172994+00
305	pay_sim_0304	synthetic	465900	INR	card	CARD_EXPIRED	Card on file expired	cust_032	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	465900	0	2026-08-21 18:16:00+00	2026-08-21 11:47:09.172994+00
306	pay_sim_0305	synthetic	392400	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_063	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	392400	2026-08-06 19:10:00+00	2026-08-21 11:47:09.172994+00
307	pay_sim_0306	synthetic	414900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_018	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	414900	0	2026-08-06 09:33:00+00	2026-08-21 11:47:09.172994+00
308	pay_sim_0307	synthetic	54600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_005	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	54600	2026-08-25 08:26:00+00	2026-08-21 11:47:09.172994+00
309	pay_sim_0308	synthetic	70500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_018	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	70500	2026-08-23 12:00:00+00	2026-08-21 11:47:09.172994+00
311	pay_sim_0310	synthetic	27700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_079	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	27700	2026-08-27 08:34:00+00	2026-08-21 11:47:09.172994+00
314	pay_sim_0313	synthetic	93800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_023	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	93800	0	2026-08-17 12:15:00+00	2026-08-21 11:47:09.172994+00
315	pay_sim_0314	synthetic	305200	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_025	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	305200	2026-08-09 20:05:00+00	2026-08-21 11:47:09.172994+00
318	pay_sim_0317	synthetic	323800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_052	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	323800	0	2026-08-18 23:03:00+00	2026-08-21 11:47:09.172994+00
320	pay_sim_0319	synthetic	447500	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_043	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	447500	2026-08-02 15:13:00+00	2026-08-21 11:47:09.172994+00
321	pay_sim_0320	synthetic	53000	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_073	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	53000	2026-08-26 10:43:00+00	2026-08-21 11:47:09.172994+00
322	pay_sim_0321	synthetic	476500	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_036	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	476500	2026-08-22 09:11:00+00	2026-08-21 11:47:09.172994+00
323	pay_sim_0322	synthetic	184600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_041	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	184600	0	2026-08-19 12:48:00+00	2026-08-21 11:47:09.172994+00
324	pay_sim_0323	synthetic	260000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_051	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	260000	0	2026-08-06 15:36:00+00	2026-08-21 11:47:09.172994+00
325	pay_sim_0324	synthetic	286600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_050	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	286600	2026-08-13 12:50:00+00	2026-08-21 11:47:09.172994+00
326	pay_sim_0325	synthetic	58800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_011	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	58800	2026-08-04 21:14:00+00	2026-08-21 11:47:09.172994+00
327	pay_sim_0326	synthetic	339800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_010	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	339800	0	2026-08-25 18:01:00+00	2026-08-21 11:47:09.172994+00
328	pay_sim_0327	synthetic	416800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_035	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	416800	0	2026-08-08 19:35:00+00	2026-08-21 11:47:09.172994+00
329	pay_sim_0328	synthetic	167000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_049	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	167000	0	2026-08-22 20:05:00+00	2026-08-21 11:47:09.172994+00
330	pay_sim_0329	synthetic	216700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_080	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	216700	2026-08-23 10:05:00+00	2026-08-21 11:47:09.172994+00
331	pay_sim_0330	synthetic	326100	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_035	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	326100	2026-08-23 12:47:00+00	2026-08-21 11:47:09.172994+00
332	pay_sim_0331	synthetic	102100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_050	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	102100	2026-08-03 08:19:00+00	2026-08-21 11:47:09.172994+00
333	pay_sim_0332	synthetic	98600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	98600	2026-08-26 12:05:00+00	2026-08-21 11:47:09.172994+00
334	pay_sim_0333	synthetic	382500	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_024	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	382500	0	2026-08-18 21:06:00+00	2026-08-21 11:47:09.172994+00
335	pay_sim_0334	synthetic	304800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_004	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	304800	0	2026-08-18 10:38:00+00	2026-08-21 11:47:09.172994+00
336	pay_sim_0335	synthetic	330400	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_077	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	330400	0	2026-08-01 17:26:00+00	2026-08-21 11:47:09.172994+00
338	pay_sim_0337	synthetic	128600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_049	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	128600	0	2026-08-09 17:17:00+00	2026-08-21 11:47:09.172994+00
339	pay_sim_0338	synthetic	151800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_064	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	151800	2026-08-24 21:17:00+00	2026-08-21 11:47:09.172994+00
340	pay_sim_0339	synthetic	411500	INR	card	CARD_EXPIRED	Card on file expired	cust_054	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	411500	0	2026-08-26 10:23:00+00	2026-08-21 11:47:09.172994+00
341	pay_sim_0340	synthetic	421000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_033	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	421000	0	2026-08-20 14:29:00+00	2026-08-21 11:47:09.172994+00
342	pay_sim_0341	synthetic	264400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_014	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	264400	0	2026-08-01 20:21:00+00	2026-08-21 11:47:09.172994+00
343	pay_sim_0342	synthetic	284800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_080	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	284800	0	2026-08-15 18:27:00+00	2026-08-21 11:47:09.172994+00
344	pay_sim_0343	synthetic	261000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_077	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	261000	2026-08-11 14:30:00+00	2026-08-21 11:47:09.172994+00
345	pay_sim_0344	synthetic	341100	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_041	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	341100	2026-08-11 17:47:00+00	2026-08-21 11:47:09.172994+00
346	pay_sim_0345	synthetic	281800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_063	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	281800	2026-08-13 16:52:00+00	2026-08-21 11:47:09.172994+00
337	pay_sim_0336	synthetic	473200	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_050	merch_001	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	473200	473200	2026-08-08 13:43:00+00	2026-08-21 11:47:09.172994+00
347	pay_sim_0346	synthetic	108100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_051	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	108100	0	2026-08-19 14:37:00+00	2026-08-21 11:47:09.172994+00
348	pay_sim_0347	synthetic	465500	INR	card	CARD_EXPIRED	Card on file expired	cust_070	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	465500	0	2026-08-01 22:45:00+00	2026-08-21 11:47:09.172994+00
349	pay_sim_0348	synthetic	71500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_027	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	71500	2026-08-26 21:43:00+00	2026-08-21 11:47:09.172994+00
350	pay_sim_0349	synthetic	262900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_064	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	262900	0	2026-08-08 16:42:00+00	2026-08-21 11:47:09.172994+00
351	pay_sim_0350	synthetic	75400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_020	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	75400	2026-08-27 22:38:00+00	2026-08-21 11:47:09.172994+00
352	pay_sim_0351	synthetic	452600	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_062	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	452600	2026-08-17 21:34:00+00	2026-08-21 11:47:09.172994+00
353	pay_sim_0352	synthetic	454700	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_005	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	454700	2026-08-20 10:06:00+00	2026-08-21 11:47:09.172994+00
354	pay_sim_0353	synthetic	151100	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_032	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	151100	0	2026-08-21 09:36:00+00	2026-08-21 11:47:09.172994+00
355	pay_sim_0354	synthetic	101600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_052	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	101600	2026-08-27 08:06:00+00	2026-08-21 11:47:09.172994+00
356	pay_sim_0355	synthetic	380000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_034	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	380000	2026-08-12 20:29:00+00	2026-08-21 11:47:09.172994+00
357	pay_sim_0356	synthetic	297400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_076	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	297400	2026-08-01 23:06:00+00	2026-08-21 11:47:09.172994+00
358	pay_sim_0357	synthetic	85200	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_038	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	85200	0	2026-08-04 12:22:00+00	2026-08-21 11:47:09.172994+00
359	pay_sim_0358	synthetic	387900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_040	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	387900	0	2026-08-26 14:33:00+00	2026-08-21 11:47:09.172994+00
360	pay_sim_0359	synthetic	404900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_062	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	404900	0	2026-08-04 22:46:00+00	2026-08-21 11:47:09.172994+00
361	pay_sim_0360	synthetic	69900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_058	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	69900	0	2026-08-10 09:51:00+00	2026-08-21 11:47:09.172994+00
362	pay_sim_0361	synthetic	295900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_015	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	295900	0	2026-08-21 11:43:00+00	2026-08-21 11:47:09.172994+00
363	pay_sim_0362	synthetic	437600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_022	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	437600	0	2026-08-06 13:21:00+00	2026-08-21 11:47:09.172994+00
364	pay_sim_0363	synthetic	204800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_072	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	204800	2026-08-26 20:40:00+00	2026-08-21 11:47:09.172994+00
365	pay_sim_0364	synthetic	368900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_024	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	368900	2026-08-13 08:47:00+00	2026-08-21 11:47:09.172994+00
366	pay_sim_0365	synthetic	366700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_079	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	366700	2026-08-27 20:00:00+00	2026-08-21 11:47:09.172994+00
367	pay_sim_0366	synthetic	242900	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_028	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	242900	0	2026-08-25 10:36:00+00	2026-08-21 11:47:09.172994+00
368	pay_sim_0367	synthetic	168000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_014	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	168000	0	2026-08-12 18:12:00+00	2026-08-21 11:47:09.172994+00
369	pay_sim_0368	synthetic	415800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_059	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	415800	2026-08-26 18:38:00+00	2026-08-21 11:47:09.172994+00
370	pay_sim_0369	synthetic	336400	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_050	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	336400	0	2026-08-19 11:22:00+00	2026-08-21 11:47:09.172994+00
371	pay_sim_0370	synthetic	156200	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_046	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	156200	2026-08-27 17:58:00+00	2026-08-21 11:47:09.172994+00
372	pay_sim_0371	synthetic	84300	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_079	merch_005	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	84300	2026-08-22 12:20:00+00	2026-08-21 11:47:09.172994+00
373	pay_sim_0372	synthetic	265000	INR	card	CARD_EXPIRED	Card on file expired	cust_016	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	265000	0	2026-08-04 13:23:00+00	2026-08-21 11:47:09.172994+00
374	pay_sim_0373	synthetic	333100	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_019	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	333100	0	2026-08-14 12:36:00+00	2026-08-21 11:47:09.172994+00
375	pay_sim_0374	synthetic	167000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_050	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	167000	2026-08-16 13:35:00+00	2026-08-21 11:47:09.172994+00
377	pay_sim_0376	synthetic	58800	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_058	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	58800	0	2026-08-28 19:00:00+00	2026-08-21 11:47:09.172994+00
379	pay_sim_0378	synthetic	350000	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_065	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	350000	2026-08-22 23:26:00+00	2026-08-21 11:47:09.172994+00
380	pay_sim_0379	synthetic	151900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_057	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	151900	0	2026-08-03 08:50:00+00	2026-08-21 11:47:09.172994+00
381	pay_sim_0380	synthetic	41600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_029	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	41600	0	2026-08-09 15:34:00+00	2026-08-21 11:47:09.172994+00
382	pay_sim_0381	synthetic	478200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_037	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	478200	2026-08-27 23:35:00+00	2026-08-21 11:47:09.172994+00
383	pay_sim_0382	synthetic	484000	INR	card	CARD_EXPIRED	Card on file expired	cust_066	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	484000	0	2026-08-04 16:49:00+00	2026-08-21 11:47:09.172994+00
384	pay_sim_0383	synthetic	458900	INR	card	CARD_EXPIRED	Card on file expired	cust_070	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	458900	0	2026-08-27 09:48:00+00	2026-08-21 11:47:09.172994+00
388	pay_sim_0387	synthetic	365600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_076	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	365600	2026-08-28 13:39:00+00	2026-08-21 11:47:09.172994+00
389	pay_sim_0388	synthetic	63500	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_018	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	63500	2026-08-25 19:34:00+00	2026-08-21 11:47:09.172994+00
391	pay_sim_0390	synthetic	484000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_038	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	484000	0	2026-08-09 11:08:00+00	2026-08-21 11:47:09.172994+00
392	pay_sim_0391	synthetic	242000	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_053	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	242000	0	2026-08-28 12:44:00+00	2026-08-21 11:47:09.172994+00
393	pay_sim_0392	synthetic	134700	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_017	merch_002	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	134700	2026-08-23 18:53:00+00	2026-08-21 11:47:09.172994+00
394	pay_sim_0393	synthetic	415800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_032	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	415800	0	2026-08-05 16:40:00+00	2026-08-21 11:47:09.172994+00
395	pay_sim_0394	synthetic	385100	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_054	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	385100	2026-08-03 10:25:00+00	2026-08-21 11:47:09.172994+00
397	pay_sim_0396	synthetic	91200	INR	card	CARD_EXPIRED	Card on file expired	cust_075	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	91200	0	2026-08-24 22:40:00+00	2026-08-21 11:47:09.172994+00
398	pay_sim_0397	synthetic	193300	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_046	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	193300	2026-08-14 14:31:00+00	2026-08-21 11:47:09.172994+00
399	pay_sim_0398	synthetic	247200	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_035	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	247200	2026-08-11 12:36:00+00	2026-08-21 11:47:09.172994+00
400	pay_sim_0399	synthetic	54500	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_063	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	54500	0	2026-08-02 11:40:00+00	2026-08-21 11:47:09.172994+00
401	pay_sim_0400	synthetic	116600	INR	card	CARD_EXPIRED	Card on file expired	cust_059	merch_001	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	116600	0	2026-08-28 13:28:00+00	2026-08-21 11:47:09.172994+00
403	pay_sim_0402	synthetic	239300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_039	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	239300	0	2026-08-03 19:16:00+00	2026-08-21 11:47:09.172994+00
405	pay_sim_0404	synthetic	366500	INR	card	CARD_EXPIRED	Card on file expired	cust_040	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	366500	0	2026-08-21 10:45:00+00	2026-08-21 11:47:09.172994+00
406	pay_sim_0405	synthetic	189700	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_013	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	189700	2026-08-16 10:08:00+00	2026-08-21 11:47:09.172994+00
407	pay_sim_0406	synthetic	440400	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_076	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	440400	0	2026-08-22 22:00:00+00	2026-08-21 11:47:09.172994+00
408	pay_sim_0407	synthetic	113600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_002	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	113600	2026-08-28 21:44:00+00	2026-08-21 11:47:09.172994+00
385	pay_sim_0384	synthetic	363100	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_057	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	protected	0	363100	2026-08-25 11:47:00+00	2026-08-21 11:47:09.172994+00
386	pay_sim_0385	synthetic	41300	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_032	merch_003	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	41300	41300	2026-08-15 16:22:00+00	2026-08-21 11:47:09.172994+00
387	pay_sim_0386	synthetic	111000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_012	merch_004	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	111000	111000	2026-08-25 15:13:00+00	2026-08-21 11:47:09.172994+00
402	pay_sim_0401	synthetic	365300	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_059	merch_001	in_session_online	t	\N	\N	\N	\N	technical	merchant	protected	365300	365300	2026-08-07 12:56:00+00	2026-08-21 11:47:09.172994+00
409	pay_sim_0408	synthetic	72900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_017	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	72900	2026-08-08 20:05:00+00	2026-08-21 11:47:09.172994+00
411	pay_sim_0410	synthetic	70900	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_049	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	70900	2026-08-25 08:39:00+00	2026-08-21 11:47:09.172994+00
412	pay_sim_0411	synthetic	189400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_022	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	189400	2026-08-26 12:58:00+00	2026-08-21 11:47:09.172994+00
414	pay_sim_0413	synthetic	115700	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_013	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	115700	0	2026-08-19 20:22:00+00	2026-08-21 11:47:09.172994+00
415	pay_sim_0414	synthetic	217800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_055	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	217800	2026-08-09 10:15:00+00	2026-08-21 11:47:09.172994+00
418	pay_sim_0417	synthetic	59600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_051	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	59600	0	2026-08-26 15:31:00+00	2026-08-21 11:47:09.172994+00
420	pay_sim_0419	synthetic	123000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_002	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	123000	2026-08-13 21:23:00+00	2026-08-21 11:47:09.172994+00
421	pay_sim_0420	synthetic	74600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_070	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	74600	2026-08-27 08:37:00+00	2026-08-21 11:47:09.172994+00
422	pay_sim_0421	synthetic	229600	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_009	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	229600	2026-08-07 09:59:00+00	2026-08-21 11:47:09.172994+00
423	pay_sim_0422	synthetic	429900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_008	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	429900	0	2026-08-10 21:27:00+00	2026-08-21 11:47:09.172994+00
424	pay_sim_0423	synthetic	454400	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_052	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	454400	0	2026-08-18 12:17:00+00	2026-08-21 11:47:09.172994+00
426	pay_sim_0425	synthetic	334900	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_020	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	334900	2026-08-19 10:19:00+00	2026-08-21 11:47:09.172994+00
427	pay_sim_0426	synthetic	62300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_056	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	62300	0	2026-08-08 10:59:00+00	2026-08-21 11:47:09.172994+00
428	pay_sim_0427	synthetic	386300	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_056	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	386300	0	2026-08-20 09:19:00+00	2026-08-21 11:47:09.172994+00
429	pay_sim_0428	synthetic	25200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_023	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	25200	0	2026-08-23 12:44:00+00	2026-08-21 11:47:09.172994+00
430	pay_sim_0429	synthetic	421500	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_002	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	421500	2026-08-12 16:10:00+00	2026-08-21 11:47:09.172994+00
432	pay_sim_0431	synthetic	237700	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_004	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	237700	2026-08-17 10:16:00+00	2026-08-21 11:47:09.172994+00
433	pay_sim_0432	synthetic	387700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_074	merch_001	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	387700	2026-08-27 19:03:00+00	2026-08-21 11:47:09.172994+00
434	pay_sim_0433	synthetic	151600	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_064	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	151600	0	2026-08-12 13:16:00+00	2026-08-21 11:47:09.172994+00
435	pay_sim_0434	synthetic	109300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_014	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	109300	0	2026-08-08 08:02:00+00	2026-08-21 11:47:09.172994+00
436	pay_sim_0435	synthetic	52500	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_002	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	52500	0	2026-08-16 19:24:00+00	2026-08-21 11:47:09.172994+00
437	pay_sim_0436	synthetic	43800	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_020	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	protected	0	43800	2026-08-18 21:14:00+00	2026-08-21 11:47:09.172994+00
438	pay_sim_0437	synthetic	355800	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_042	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	355800	0	2026-08-24 18:17:00+00	2026-08-21 11:47:09.172994+00
439	pay_sim_0438	synthetic	112700	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_010	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	112700	2026-08-26 09:11:00+00	2026-08-21 11:47:09.172994+00
431	pay_sim_0430	synthetic	235000	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_048	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	235000	235000	2026-08-24 11:49:00+00	2026-08-21 11:47:09.172994+00
441	pay_sim_0440	synthetic	269400	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_060	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	269400	0	2026-08-11 10:35:00+00	2026-08-21 11:47:09.172994+00
442	pay_sim_0441	synthetic	317100	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_059	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	317100	0	2026-08-07 17:36:00+00	2026-08-21 11:47:09.172994+00
443	pay_sim_0442	synthetic	213600	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_039	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	213600	0	2026-08-15 19:37:00+00	2026-08-21 11:47:09.172994+00
444	pay_sim_0443	synthetic	462600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_064	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	462600	2026-08-25 15:09:00+00	2026-08-21 11:47:09.172994+00
445	pay_sim_0444	synthetic	34400	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_001	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	34400	2026-08-08 19:40:00+00	2026-08-21 11:47:09.172994+00
446	pay_sim_0445	synthetic	323100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_002	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	323100	2026-08-28 17:06:00+00	2026-08-21 11:47:09.172994+00
447	pay_sim_0446	synthetic	210000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_027	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	210000	0	2026-08-14 23:03:00+00	2026-08-21 11:47:09.172994+00
448	pay_sim_0447	synthetic	91100	INR	card	CARD_EXPIRED	Card on file expired	cust_019	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	91100	0	2026-08-02 15:57:00+00	2026-08-21 11:47:09.172994+00
449	pay_sim_0448	synthetic	390400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_067	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	390400	2026-08-26 10:37:00+00	2026-08-21 11:47:09.172994+00
450	pay_sim_0449	synthetic	124200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_013	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	124200	0	2026-08-21 20:04:00+00	2026-08-21 11:47:09.172994+00
451	pay_sim_0450	synthetic	371200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_076	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	371200	2026-08-24 12:15:00+00	2026-08-21 11:47:09.172994+00
452	pay_sim_0451	synthetic	336800	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_038	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	336800	2026-08-23 18:20:00+00	2026-08-21 11:47:09.172994+00
453	pay_sim_0452	synthetic	206200	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_058	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	206200	2026-08-03 14:08:00+00	2026-08-21 11:47:09.172994+00
454	pay_sim_0453	synthetic	142200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_075	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	142200	0	2026-08-04 13:28:00+00	2026-08-21 11:47:09.172994+00
455	pay_sim_0454	synthetic	113800	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_060	merch_003	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	113800	2026-08-27 19:49:00+00	2026-08-21 11:47:09.172994+00
456	pay_sim_0455	synthetic	394400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_027	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	394400	2026-08-09 11:05:00+00	2026-08-21 11:47:09.172994+00
457	pay_sim_0456	synthetic	191000	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_021	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	191000	2026-08-27 18:09:00+00	2026-08-21 11:47:09.172994+00
458	pay_sim_0457	synthetic	306300	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_012	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	306300	0	2026-08-13 09:43:00+00	2026-08-21 11:47:09.172994+00
459	pay_sim_0458	synthetic	157300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_039	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	157300	0	2026-08-01 20:54:00+00	2026-08-21 11:47:09.172994+00
460	pay_sim_0459	synthetic	465500	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_058	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	465500	0	2026-08-08 11:29:00+00	2026-08-21 11:47:09.172994+00
461	pay_sim_0460	synthetic	114300	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_014	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	114300	0	2026-08-01 09:53:00+00	2026-08-21 11:47:09.172994+00
462	pay_sim_0461	synthetic	177200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_029	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	177200	0	2026-08-27 20:23:00+00	2026-08-21 11:47:09.172994+00
463	pay_sim_0462	synthetic	495000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_011	merch_005	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	495000	0	2026-08-09 10:01:00+00	2026-08-21 11:47:09.172994+00
464	pay_sim_0463	synthetic	120400	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_009	merch_005	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	120400	2026-08-03 18:07:00+00	2026-08-21 11:47:09.172994+00
465	pay_sim_0464	synthetic	56300	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_006	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	56300	2026-08-06 21:52:00+00	2026-08-21 11:47:09.172994+00
466	pay_sim_0465	synthetic	328400	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_051	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	328400	2026-08-24 21:11:00+00	2026-08-21 11:47:09.172994+00
467	pay_sim_0466	synthetic	168200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_046	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	168200	0	2026-08-09 16:28:00+00	2026-08-21 11:47:09.172994+00
468	pay_sim_0467	synthetic	216200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_020	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	216200	0	2026-08-21 17:31:00+00	2026-08-21 11:47:09.172994+00
470	pay_sim_0469	synthetic	358300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_050	merch_002	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	358300	0	2026-08-07 15:40:00+00	2026-08-21 11:47:09.172994+00
471	pay_sim_0470	synthetic	328200	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_070	merch_001	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	328200	2026-08-26 19:30:00+00	2026-08-21 11:47:09.172994+00
472	pay_sim_0471	synthetic	296700	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_070	merch_004	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	296700	2026-08-19 18:24:00+00	2026-08-21 11:47:09.172994+00
473	pay_sim_0472	synthetic	36200	INR	card	CARD_EXPIRED	Card on file expired	cust_035	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	36200	0	2026-08-11 15:01:00+00	2026-08-21 11:47:09.172994+00
474	pay_sim_0473	synthetic	401300	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_036	merch_001	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	401300	0	2026-08-17 19:49:00+00	2026-08-21 11:47:09.172994+00
475	pay_sim_0474	synthetic	145600	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_075	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	145600	2026-08-04 15:42:00+00	2026-08-21 11:47:09.172994+00
476	pay_sim_0475	synthetic	452000	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_031	merch_003	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	452000	0	2026-08-27 09:48:00+00	2026-08-21 11:47:09.172994+00
477	pay_sim_0476	synthetic	333000	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_029	merch_005	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	333000	0	2026-08-12 13:11:00+00	2026-08-21 11:47:09.172994+00
478	pay_sim_0477	synthetic	275400	INR	upi	CHECKOUT_CONFIG_ERROR	Merchant checkout misconfiguration rejected payment payload	cust_031	merch_005	in_session_online	t	\N	\N	\N	\N	technical	merchant	recovered	275400	0	2026-08-26 19:58:00+00	2026-08-21 11:47:09.172994+00
479	pay_sim_0478	synthetic	302900	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_076	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	protected	0	302900	2026-08-19 12:36:00+00	2026-08-21 11:47:09.172994+00
480	pay_sim_0479	synthetic	459000	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_025	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	459000	0	2026-08-10 13:31:00+00	2026-08-21 11:47:09.172994+00
481	pay_sim_0480	synthetic	60900	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_005	merch_001	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	60900	0	2026-08-08 15:01:00+00	2026-08-21 11:47:09.172994+00
482	pay_sim_0481	synthetic	286600	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_068	merch_004	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	286600	2026-08-24 14:51:00+00	2026-08-21 11:47:09.172994+00
483	pay_sim_0482	synthetic	160200	INR	card	CARD_EXPIRED	Card on file expired	cust_017	merch_003	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	160200	0	2026-08-26 18:03:00+00	2026-08-21 11:47:09.172994+00
484	pay_sim_0483	synthetic	495400	INR	card	CARD_EXPIRED	Card on file expired	cust_003	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	495400	0	2026-08-23 12:49:00+00	2026-08-21 11:47:09.172994+00
485	pay_sim_0484	synthetic	74300	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_015	merch_005	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	74300	2026-08-26 19:45:00+00	2026-08-21 11:47:09.172994+00
488	pay_sim_0487	synthetic	307200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_041	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	307200	2026-08-28 15:42:00+00	2026-08-21 11:47:09.172994+00
489	pay_sim_0488	synthetic	266200	INR	upi	INSUFFICIENT_BALANCE	Bank declined: insufficient balance	cust_076	merch_002	in_session_online	t	\N	\N	\N	\N	affordability	customer_temp	deferred	0	266200	2026-08-27 17:08:00+00	2026-08-21 11:47:09.172994+00
491	pay_sim_0490	synthetic	195800	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_078	merch_003	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	195800	0	2026-08-21 11:59:00+00	2026-08-21 11:47:09.172994+00
492	pay_sim_0491	synthetic	286100	INR	card	GATEWAY_5XX	Issuer gateway returned 502 during authorization	cust_064	merch_002	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	286100	0	2026-08-24 10:15:00+00	2026-08-21 11:47:09.172994+00
493	pay_sim_0492	synthetic	152400	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_045	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	152400	2026-08-21 10:52:00+00	2026-08-21 11:47:09.172994+00
494	pay_sim_0493	synthetic	24200	INR	upi	UPI_BANK_TIMEOUT	UPI request timed out at PSP; bank server degraded	cust_043	merch_004	in_session_online	t	\N	\N	\N	\N	technical	infra	recovered	24200	0	2026-08-09 14:15:00+00	2026-08-21 11:47:09.172994+00
495	pay_sim_0494	synthetic	225100	INR	card	REPEATED_INSUFFICIENT_BALANCE	4th consecutive cycle declined for insufficient balance	cust_009	merch_003	recurring	f	\N	\N	\N	\N	affordability	customer_structural	protected	0	225100	2026-08-26 11:46:00+00	2026-08-21 11:47:09.172994+00
497	pay_sim_0496	synthetic	325100	INR	card	CARD_EXPIRED	Card on file expired	cust_053	merch_004	recurring	f	\N	\N	\N	\N	lifecycle	customer_temp	recovered	325100	0	2026-08-12 20:06:00+00	2026-08-21 11:47:09.172994+00
498	pay_sim_0497	synthetic	148100	INR	upi	MANDATE_NOTIFICATION_BREACH	E-mandate charge blocked; pre-debit notification sent <24h before debit	cust_062	merch_002	recurring	f	\N	\N	\N	\N	lifecycle	merchant	protected	0	148100	2026-08-15 10:51:00+00	2026-08-21 11:47:09.172994+00
500	pay_sim_0499	synthetic	154200	INR	card	ABANDONED_AT_OTP	Order created; user dropped at OTP step	cust_010	merch_003	post_session_online	f	otp	\N	\N	\N	intent	customer_temp	recovered	154200	0	2026-08-13 13:46:00+00	2026-08-21 11:47:09.172994+00
486	pay_sim_0485	synthetic	97600	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_051	merch_005	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	97600	97600	2026-08-11 17:20:00+00	2026-08-21 11:47:09.172994+00
487	pay_sim_0486	synthetic	372700	INR	upi	OFFLINE_QR_TIMEOUT	QR scan timed out in-store; customer left before completion	cust_018	merch_002	post_session_offline	f	\N	\N	\N	\N	technical	infra	recovered	372700	372700	2026-08-26 23:41:00+00	2026-08-21 11:47:09.172994+00
499	pay_sim_0498	synthetic	31300	INR	upi	ABANDONED_AT_FEES	Order created; session dropped at fee reveal before payment attempt	cust_005	merch_003	post_session_online	f	fees	\N	\N	\N	intent	merchant	recovered	31300	31300	2026-08-11 16:06:00+00	2026-08-21 11:47:09.172994+00
\.


--
-- Data for Name: recovery_actions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recovery_actions (id, failure_id, action_type, actor, reasoning, status, amount_recovered_paise, executed_at) FROM stdin;
4002	16	RETRY_LINK	system	\N	executed	440000	2026-08-22 20:53:25.607504+00
4003	17	RETRY_LINK	system	\N	executed	494400	2026-08-22 20:53:25.607504+00
4004	19	RETRY_LINK	system	\N	executed	285000	2026-08-22 20:53:25.607504+00
4005	116	RETRY_LINK	system	\N	executed	311300	2026-08-22 20:53:25.607504+00
4006	117	RETRY_LINK	system	\N	executed	371800	2026-08-22 20:53:25.607504+00
4007	119	RETRY_LINK	system	\N	executed	77400	2026-08-22 20:53:25.607504+00
4008	125	RETRY_LINK	system	\N	executed	499300	2026-08-22 20:53:25.607504+00
4009	131	RETRY_LINK	system	\N	executed	374800	2026-08-22 20:53:25.607504+00
4010	137	RETRY_LINK	system	\N	executed	446100	2026-08-22 20:53:25.607504+00
4011	187	RETRY_LINK	system	\N	executed	115300	2026-08-22 20:53:25.607504+00
4012	196	RETRY_LINK	system	\N	executed	297100	2026-08-22 20:53:25.607504+00
4013	204	RETRY_LINK	system	\N	executed	187500	2026-08-22 20:53:25.607504+00
4014	178	RETRY_LINK	system	\N	executed	61800	2026-08-22 20:53:25.607504+00
4015	210	RETRY_LINK	system	\N	executed	276300	2026-08-22 20:53:25.607504+00
4016	296	RETRY_LINK	system	\N	executed	192600	2026-08-22 20:53:25.607504+00
4017	304	RETRY_LINK	system	\N	executed	285100	2026-08-22 20:53:25.607504+00
4018	316	RETRY_LINK	system	\N	executed	390900	2026-08-22 20:53:25.607504+00
4019	317	RETRY_LINK	system	\N	executed	80900	2026-08-22 20:53:25.607504+00
4020	319	RETRY_LINK	system	\N	executed	82600	2026-08-22 20:53:25.607504+00
4021	396	RETRY_LINK	system	\N	executed	317200	2026-08-22 20:53:25.607504+00
4022	404	RETRY_LINK	system	\N	executed	150400	2026-08-22 20:53:25.607504+00
4023	416	RETRY_LINK	system	\N	executed	248300	2026-08-22 20:53:25.607504+00
4024	417	RETRY_LINK	system	\N	executed	439000	2026-08-22 20:53:25.607504+00
4025	419	RETRY_LINK	system	\N	executed	212300	2026-08-22 20:53:25.607504+00
4026	290	RETRY_LINK	system	\N	executed	165500	2026-08-22 20:53:25.607504+00
4027	302	RETRY_LINK	system	\N	executed	196100	2026-08-22 20:53:25.607504+00
4028	310	RETRY_LINK	system	\N	executed	388400	2026-08-22 20:53:25.607504+00
4029	312	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4030	313	RETRY_LINK	system	\N	executed	426300	2026-08-22 20:53:25.607504+00
4031	376	RETRY_LINK	system	\N	executed	251500	2026-08-22 20:53:25.607504+00
4032	73	RETRY_LINK	system	\N	executed	170300	2026-08-22 20:53:25.607504+00
4033	378	RETRY_LINK	system	\N	executed	174700	2026-08-22 20:53:25.607504+00
4034	390	RETRY_LINK	system	\N	executed	456200	2026-08-22 20:53:25.607504+00
4035	410	RETRY_LINK	system	\N	executed	271500	2026-08-22 20:53:25.607504+00
4036	413	RETRY_LINK	system	\N	executed	377300	2026-08-22 20:53:25.607504+00
4037	490	RETRY_LINK	system	\N	executed	484100	2026-08-22 20:53:25.607504+00
4038	10	RETRY_LINK	system	\N	executed	232500	2026-08-22 20:53:25.607504+00
4039	12	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4040	13	RETRY_LINK	system	\N	executed	373500	2026-08-22 20:53:25.607504+00
4041	86	RETRY_LINK	system	\N	executed	494400	2026-08-22 20:53:25.607504+00
4042	90	RETRY_LINK	system	\N	executed	364500	2026-08-22 20:53:25.607504+00
4043	102	RETRY_LINK	system	\N	executed	323000	2026-08-22 20:53:25.607504+00
4044	185	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4045	212	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4046	213	RETRY_LINK	system	\N	executed	488100	2026-08-22 20:53:25.607504+00
4047	469	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4048	37	BLOCKED	system	Customer left store. Silent retry blocked to prevent double-charge.	blocked	0	2026-08-22 20:53:25.607504+00
4049	121	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4050	216	RETRY_LINK	system	\N	executed	303900	2026-08-22 20:53:25.607504+00
4051	217	RETRY_LINK	system	\N	executed	400400	2026-08-22 20:53:25.607504+00
4052	219	RETRY_LINK	system	\N	executed	51900	2026-08-22 20:53:25.607504+00
4053	225	RETRY_LINK	system	\N	executed	389200	2026-08-22 20:53:25.607504+00
4054	231	RETRY_LINK	system	\N	executed	408400	2026-08-22 20:53:25.607504+00
4055	278	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4056	286	RETRY_LINK	system	\N	executed	195900	2026-08-22 20:53:25.607504+00
4057	287	RETRY_LINK	system	\N	executed	499500	2026-08-22 20:53:25.607504+00
4058	425	RETRY_LINK	system	\N	executed	79600	2026-08-22 20:53:25.607504+00
4059	496	RETRY_LINK	system	\N	executed	331000	2026-08-22 20:53:25.607504+00
4060	140	RETRY_LINK	system	\N	executed	97700	2026-08-22 20:53:25.607504+00
4061	44	RETRY_LINK	system	\N	executed	95500	2026-08-22 20:53:25.607504+00
4062	45	RETRY_LINK	system	\N	executed	38600	2026-08-22 20:53:25.607504+00
4063	158	RETRY_LINK	system	\N	executed	66300	2026-08-22 20:53:25.607504+00
4064	240	RETRY_LINK	system	\N	executed	114700	2026-08-22 20:53:25.607504+00
4065	283	RETRY_LINK	system	\N	executed	51100	2026-08-22 20:53:25.607504+00
4066	284	RETRY_LINK	system	\N	executed	61100	2026-08-22 20:53:25.607504+00
4067	440	RETRY_LINK	system	\N	executed	52500	2026-08-22 20:53:25.607504+00
4068	4	RETRY_LINK	system	\N	executed	96100	2026-08-22 20:53:25.607504+00
4069	1	RETRY_LINK	system	\N	executed	111900	2026-08-22 20:53:25.607504+00
4070	3	RETRY_LINK	system	\N	executed	497000	2026-08-22 20:53:25.607504+00
4071	5	RETRY_LINK	system	\N	executed	81400	2026-08-22 20:53:25.607504+00
4072	6	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4073	7	RETRY_LINK	system	\N	executed	253400	2026-08-22 20:53:25.607504+00
4074	8	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4075	9	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4076	11	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4077	14	RETRY_LINK	system	\N	executed	220000	2026-08-22 20:53:25.607504+00
4078	15	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4079	18	RETRY_LINK	system	\N	executed	349400	2026-08-22 20:53:25.607504+00
4080	20	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4081	21	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4082	22	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4083	23	RETRY_LINK	system	\N	executed	423200	2026-08-22 20:53:25.607504+00
4084	24	RETRY_LINK	system	\N	executed	233600	2026-08-22 20:53:25.607504+00
4085	26	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4086	27	RETRY_LINK	system	\N	executed	198900	2026-08-22 20:53:25.607504+00
4087	28	RETRY_LINK	system	\N	executed	423100	2026-08-22 20:53:25.607504+00
4088	29	RETRY_LINK	system	\N	executed	410100	2026-08-22 20:53:25.607504+00
4089	30	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4090	2	RETRY_LINK	system	\N	executed	199700	2026-08-22 20:53:25.607504+00
4091	25	RETRY_LINK	system	\N	executed	411900	2026-08-22 20:53:25.607504+00
4092	32	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4093	33	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4094	34	RETRY_LINK	system	\N	executed	323900	2026-08-22 20:53:25.607504+00
4095	35	RETRY_LINK	system	\N	executed	483300	2026-08-22 20:53:25.607504+00
4096	36	RETRY_LINK	system	\N	executed	275500	2026-08-22 20:53:25.607504+00
4097	38	RETRY_LINK	system	\N	executed	286800	2026-08-22 20:53:25.607504+00
4098	40	RETRY_LINK	system	\N	executed	141300	2026-08-22 20:53:25.607504+00
4099	41	RETRY_LINK	system	\N	executed	340500	2026-08-22 20:53:25.607504+00
4100	42	RETRY_LINK	system	\N	executed	326200	2026-08-22 20:53:25.607504+00
4101	43	RETRY_LINK	system	\N	executed	70900	2026-08-22 20:53:25.607504+00
4102	46	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4103	47	RETRY_LINK	system	\N	executed	478500	2026-08-22 20:53:25.607504+00
4104	48	RETRY_LINK	system	\N	executed	328200	2026-08-22 20:53:25.607504+00
4105	49	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4106	50	RETRY_LINK	system	\N	executed	396000	2026-08-22 20:53:25.607504+00
4107	51	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4108	52	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4109	53	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4110	54	RETRY_LINK	system	\N	executed	339100	2026-08-22 20:53:25.607504+00
4111	55	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4112	56	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4113	57	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4114	58	RETRY_LINK	system	\N	executed	256600	2026-08-22 20:53:25.607504+00
4115	59	RETRY_LINK	system	\N	executed	456700	2026-08-22 20:53:25.607504+00
4116	60	RETRY_LINK	system	\N	executed	409600	2026-08-22 20:53:25.607504+00
4117	61	RETRY_LINK	system	\N	executed	398500	2026-08-22 20:53:25.607504+00
4118	39	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4119	31	RETRY_LINK	system	\N	executed	354800	2026-08-22 20:53:25.607504+00
4120	62	RETRY_LINK	system	\N	executed	471400	2026-08-22 20:53:25.607504+00
4121	63	RETRY_LINK	system	\N	executed	231500	2026-08-22 20:53:25.607504+00
4122	64	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4123	65	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4124	66	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4125	67	RETRY_LINK	system	\N	executed	264200	2026-08-22 20:53:25.607504+00
4126	68	RETRY_LINK	system	\N	executed	126000	2026-08-22 20:53:25.607504+00
4127	69	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4128	70	RETRY_LINK	system	\N	executed	349200	2026-08-22 20:53:25.607504+00
4129	71	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4130	72	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4131	74	RETRY_LINK	system	\N	executed	32300	2026-08-22 20:53:25.607504+00
4132	75	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4133	76	RETRY_LINK	system	\N	executed	284000	2026-08-22 20:53:25.607504+00
4134	77	RETRY_LINK	system	\N	executed	242000	2026-08-22 20:53:25.607504+00
4135	79	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4136	80	RETRY_LINK	system	\N	executed	57800	2026-08-22 20:53:25.607504+00
4137	81	RETRY_LINK	system	\N	executed	405000	2026-08-22 20:53:25.607504+00
4138	82	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4139	83	RETRY_LINK	system	\N	executed	261900	2026-08-22 20:53:25.607504+00
4140	84	RETRY_LINK	system	\N	executed	364100	2026-08-22 20:53:25.607504+00
4141	85	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4142	88	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4143	89	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4144	91	RETRY_LINK	system	\N	executed	69800	2026-08-22 20:53:25.607504+00
4145	92	RETRY_LINK	system	\N	executed	320100	2026-08-22 20:53:25.607504+00
4146	93	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4147	87	RETRY_LINK	system	\N	executed	256400	2026-08-22 20:53:25.607504+00
4148	78	RETRY_LINK	system	\N	executed	157800	2026-08-22 20:53:25.607504+00
4149	94	RETRY_LINK	system	\N	executed	304500	2026-08-22 20:53:25.607504+00
4150	95	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4151	97	RETRY_LINK	system	\N	executed	470500	2026-08-22 20:53:25.607504+00
4152	98	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4153	99	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4154	100	RETRY_LINK	system	\N	executed	19900	2026-08-22 20:53:25.607504+00
4155	101	RETRY_LINK	system	\N	executed	131100	2026-08-22 20:53:25.607504+00
4156	103	RETRY_LINK	system	\N	executed	270100	2026-08-22 20:53:25.607504+00
4157	104	BLOCKED	system	Customer left store. Silent retry blocked to prevent double-charge.	blocked	0	2026-08-22 20:53:25.607504+00
4158	105	RETRY_LINK	system	\N	executed	81700	2026-08-22 20:53:25.607504+00
4159	106	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4160	107	RETRY_LINK	system	\N	executed	297600	2026-08-22 20:53:25.607504+00
4161	108	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4162	111	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4163	114	RETRY_LINK	system	\N	executed	486500	2026-08-22 20:53:25.607504+00
4164	115	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4165	118	RETRY_LINK	system	\N	executed	269000	2026-08-22 20:53:25.607504+00
4166	120	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4167	122	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4168	123	RETRY_LINK	system	\N	executed	382600	2026-08-22 20:53:25.607504+00
4169	124	RETRY_LINK	system	\N	executed	375100	2026-08-22 20:53:25.607504+00
4170	110	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4171	113	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4172	109	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4173	112	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4174	96	RETRY_LINK	system	\N	executed	141600	2026-08-22 20:53:25.607504+00
4175	126	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4176	127	RETRY_LINK	system	\N	executed	88800	2026-08-22 20:53:25.607504+00
4177	128	RETRY_LINK	system	\N	executed	48500	2026-08-22 20:53:25.607504+00
4178	129	RETRY_LINK	system	\N	executed	425600	2026-08-22 20:53:25.607504+00
4179	130	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4180	132	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4181	133	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4182	134	RETRY_LINK	system	\N	executed	247600	2026-08-22 20:53:25.607504+00
4183	135	RETRY_LINK	system	\N	executed	130700	2026-08-22 20:53:25.607504+00
4184	136	RETRY_LINK	system	\N	executed	84300	2026-08-22 20:53:25.607504+00
4185	138	RETRY_LINK	system	\N	executed	311900	2026-08-22 20:53:25.607504+00
4186	139	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4187	141	RETRY_LINK	system	\N	executed	122200	2026-08-22 20:53:25.607504+00
4188	142	RETRY_LINK	system	\N	executed	150500	2026-08-22 20:53:25.607504+00
4189	143	RETRY_LINK	system	\N	executed	209400	2026-08-22 20:53:25.607504+00
4190	144	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4191	145	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4192	146	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4193	147	RETRY_LINK	system	\N	executed	219700	2026-08-22 20:53:25.607504+00
4194	148	RETRY_LINK	system	\N	executed	98900	2026-08-22 20:53:25.607504+00
4195	149	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4196	150	RETRY_LINK	system	\N	executed	196700	2026-08-22 20:53:25.607504+00
4197	151	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4198	152	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4199	153	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4200	154	RETRY_LINK	system	\N	executed	401900	2026-08-22 20:53:25.607504+00
4201	155	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4202	156	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4203	157	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4204	159	RETRY_LINK	system	\N	executed	437000	2026-08-22 20:53:25.607504+00
4205	160	RETRY_LINK	system	\N	executed	366500	2026-08-22 20:53:25.607504+00
4206	161	RETRY_LINK	system	\N	executed	168300	2026-08-22 20:53:25.607504+00
4207	162	RETRY_LINK	system	\N	executed	445800	2026-08-22 20:53:25.607504+00
4208	163	RETRY_LINK	system	\N	executed	331800	2026-08-22 20:53:25.607504+00
4209	164	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4210	165	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4211	166	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4212	167	RETRY_LINK	system	\N	executed	389800	2026-08-22 20:53:25.607504+00
4213	168	RETRY_LINK	system	\N	executed	49200	2026-08-22 20:53:25.607504+00
4214	169	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4215	170	RETRY_LINK	system	\N	executed	307300	2026-08-22 20:53:25.607504+00
4216	171	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4217	172	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4218	173	RETRY_LINK	system	\N	executed	440200	2026-08-22 20:53:25.607504+00
4219	174	RETRY_LINK	system	\N	executed	367600	2026-08-22 20:53:25.607504+00
4220	175	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4221	176	RETRY_LINK	system	\N	executed	380100	2026-08-22 20:53:25.607504+00
4222	177	RETRY_LINK	system	\N	executed	381100	2026-08-22 20:53:25.607504+00
4223	179	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4224	180	RETRY_LINK	system	\N	executed	208200	2026-08-22 20:53:25.607504+00
4225	181	RETRY_LINK	system	\N	executed	41400	2026-08-22 20:53:25.607504+00
4226	182	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4227	183	RETRY_LINK	system	\N	executed	315500	2026-08-22 20:53:25.607504+00
4228	184	RETRY_LINK	system	\N	executed	107800	2026-08-22 20:53:25.607504+00
4229	186	BLOCKED	system	Customer left store. Silent retry blocked to prevent double-charge.	blocked	0	2026-08-22 20:53:25.607504+00
4230	188	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4231	189	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4232	190	RETRY_LINK	system	\N	executed	311000	2026-08-22 20:53:25.607504+00
4233	191	RETRY_LINK	system	\N	executed	208800	2026-08-22 20:53:25.607504+00
4234	192	RETRY_LINK	system	\N	executed	483700	2026-08-22 20:53:25.607504+00
4235	193	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4236	194	RETRY_LINK	system	\N	executed	351400	2026-08-22 20:53:25.607504+00
4237	195	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4238	197	RETRY_LINK	system	\N	executed	426800	2026-08-22 20:53:25.607504+00
4239	198	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4240	199	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4241	200	RETRY_LINK	system	\N	executed	239700	2026-08-22 20:53:25.607504+00
4242	201	RETRY_LINK	system	\N	executed	426600	2026-08-22 20:53:25.607504+00
4243	203	RETRY_LINK	system	\N	executed	38100	2026-08-22 20:53:25.607504+00
4244	205	RETRY_LINK	system	\N	executed	461800	2026-08-22 20:53:25.607504+00
4245	206	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4246	207	RETRY_LINK	system	\N	executed	375000	2026-08-22 20:53:25.607504+00
4247	208	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4248	209	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4249	211	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4250	214	RETRY_LINK	system	\N	executed	436500	2026-08-22 20:53:25.607504+00
4251	215	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4252	218	RETRY_LINK	system	\N	executed	124600	2026-08-22 20:53:25.607504+00
4253	202	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4254	220	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4255	221	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4256	222	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4257	223	RETRY_LINK	system	\N	executed	177900	2026-08-22 20:53:25.607504+00
4258	224	RETRY_LINK	system	\N	executed	46700	2026-08-22 20:53:25.607504+00
4259	226	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4260	227	RETRY_LINK	system	\N	executed	432400	2026-08-22 20:53:25.607504+00
4261	228	RETRY_LINK	system	\N	executed	403900	2026-08-22 20:53:25.607504+00
4262	229	RETRY_LINK	system	\N	executed	356100	2026-08-22 20:53:25.607504+00
4263	230	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4264	232	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4265	233	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4266	234	RETRY_LINK	system	\N	executed	65900	2026-08-22 20:53:25.607504+00
4267	235	RETRY_LINK	system	\N	executed	281100	2026-08-22 20:53:25.607504+00
4268	236	RETRY_LINK	system	\N	executed	156700	2026-08-22 20:53:25.607504+00
4269	238	RETRY_LINK	system	\N	executed	199100	2026-08-22 20:53:25.607504+00
4270	239	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4271	241	RETRY_LINK	system	\N	executed	134800	2026-08-22 20:53:25.607504+00
4272	242	RETRY_LINK	system	\N	executed	377200	2026-08-22 20:53:25.607504+00
4273	243	RETRY_LINK	system	\N	executed	180400	2026-08-22 20:53:25.607504+00
4274	244	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4275	245	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4276	246	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4277	247	RETRY_LINK	system	\N	executed	348200	2026-08-22 20:53:25.607504+00
4278	248	RETRY_LINK	system	\N	executed	278000	2026-08-22 20:53:25.607504+00
4279	249	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4280	250	RETRY_LINK	system	\N	executed	158900	2026-08-22 20:53:25.607504+00
4281	251	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4282	237	RETRY_LINK	system	\N	executed	411500	2026-08-22 20:53:25.607504+00
4283	252	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4284	253	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4285	254	RETRY_LINK	system	\N	executed	285700	2026-08-22 20:53:25.607504+00
4286	255	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4287	256	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4288	257	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4289	258	RETRY_LINK	system	\N	executed	228500	2026-08-22 20:53:25.607504+00
4290	259	RETRY_LINK	system	\N	executed	262200	2026-08-22 20:53:25.607504+00
4291	260	RETRY_LINK	system	\N	executed	65700	2026-08-22 20:53:25.607504+00
4292	261	RETRY_LINK	system	\N	executed	347000	2026-08-22 20:53:25.607504+00
4293	262	RETRY_LINK	system	\N	executed	315900	2026-08-22 20:53:25.607504+00
4294	263	RETRY_LINK	system	\N	executed	140300	2026-08-22 20:53:25.607504+00
4295	264	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4296	265	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4297	266	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4298	267	RETRY_LINK	system	\N	executed	376800	2026-08-22 20:53:25.607504+00
4299	268	RETRY_LINK	system	\N	executed	89300	2026-08-22 20:53:25.607504+00
4300	270	RETRY_LINK	system	\N	executed	472600	2026-08-22 20:53:25.607504+00
4301	271	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4302	272	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4303	273	RETRY_LINK	system	\N	executed	64200	2026-08-22 20:53:25.607504+00
4304	274	RETRY_LINK	system	\N	executed	162300	2026-08-22 20:53:25.607504+00
4305	275	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4306	276	RETRY_LINK	system	\N	executed	123800	2026-08-22 20:53:25.607504+00
4307	277	RETRY_LINK	system	\N	executed	336800	2026-08-22 20:53:25.607504+00
4308	279	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4309	280	RETRY_LINK	system	\N	executed	141900	2026-08-22 20:53:25.607504+00
4310	281	RETRY_LINK	system	\N	executed	358300	2026-08-22 20:53:25.607504+00
4311	282	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4312	269	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4313	285	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4314	288	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4315	289	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4316	291	RETRY_LINK	system	\N	executed	133100	2026-08-22 20:53:25.607504+00
4317	292	RETRY_LINK	system	\N	executed	352900	2026-08-22 20:53:25.607504+00
4318	293	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4319	294	RETRY_LINK	system	\N	executed	90600	2026-08-22 20:53:25.607504+00
4320	295	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4321	297	RETRY_LINK	system	\N	executed	27400	2026-08-22 20:53:25.607504+00
4322	298	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4323	299	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4324	300	RETRY_LINK	system	\N	executed	434900	2026-08-22 20:53:25.607504+00
4325	301	RETRY_LINK	system	\N	executed	181300	2026-08-22 20:53:25.607504+00
4326	303	RETRY_LINK	system	\N	executed	493300	2026-08-22 20:53:25.607504+00
4327	305	RETRY_LINK	system	\N	executed	465900	2026-08-22 20:53:25.607504+00
4328	306	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4329	307	RETRY_LINK	system	\N	executed	414900	2026-08-22 20:53:25.607504+00
4330	308	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4331	309	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4332	311	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4333	314	RETRY_LINK	system	\N	executed	93800	2026-08-22 20:53:25.607504+00
4334	315	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4335	318	RETRY_LINK	system	\N	executed	323800	2026-08-22 20:53:25.607504+00
4336	320	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4337	321	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4338	322	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4339	323	RETRY_LINK	system	\N	executed	184600	2026-08-22 20:53:25.607504+00
4340	324	RETRY_LINK	system	\N	executed	260000	2026-08-22 20:53:25.607504+00
4502	501	RETRY_LINK	system	\N	executed	49900	2026-08-22 20:57:20.308257+00
4341	325	BLOCKED	system	Customer left store. Silent retry blocked to prevent double-charge.	blocked	0	2026-08-22 20:53:25.607504+00
4342	326	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4343	327	RETRY_LINK	system	\N	executed	339800	2026-08-22 20:53:25.607504+00
4344	328	RETRY_LINK	system	\N	executed	416800	2026-08-22 20:53:25.607504+00
4345	329	RETRY_LINK	system	\N	executed	167000	2026-08-22 20:53:25.607504+00
4346	330	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4347	331	BLOCKED	system	Customer left store. Silent retry blocked to prevent double-charge.	blocked	0	2026-08-22 20:53:25.607504+00
4348	332	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4349	333	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4350	334	RETRY_LINK	system	\N	executed	382500	2026-08-22 20:53:25.607504+00
4351	335	RETRY_LINK	system	\N	executed	304800	2026-08-22 20:53:25.607504+00
4352	336	RETRY_LINK	system	\N	executed	330400	2026-08-22 20:53:25.607504+00
4353	338	RETRY_LINK	system	\N	executed	128600	2026-08-22 20:53:25.607504+00
4354	339	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4355	340	RETRY_LINK	system	\N	executed	411500	2026-08-22 20:53:25.607504+00
4356	341	RETRY_LINK	system	\N	executed	421000	2026-08-22 20:53:25.607504+00
4357	342	RETRY_LINK	system	\N	executed	264400	2026-08-22 20:53:25.607504+00
4358	343	RETRY_LINK	system	\N	executed	284800	2026-08-22 20:53:25.607504+00
4359	344	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4360	345	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4361	346	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4362	337	RETRY_LINK	system	\N	executed	473200	2026-08-22 20:53:25.607504+00
4363	347	RETRY_LINK	system	\N	executed	108100	2026-08-22 20:53:25.607504+00
4364	348	RETRY_LINK	system	\N	executed	465500	2026-08-22 20:53:25.607504+00
4365	349	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4366	350	RETRY_LINK	system	\N	executed	262900	2026-08-22 20:53:25.607504+00
4367	351	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4368	352	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4369	353	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4370	354	RETRY_LINK	system	\N	executed	151100	2026-08-22 20:53:25.607504+00
4371	355	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4372	356	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4373	357	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4374	358	RETRY_LINK	system	\N	executed	85200	2026-08-22 20:53:25.607504+00
4375	359	RETRY_LINK	system	\N	executed	387900	2026-08-22 20:53:25.607504+00
4376	360	RETRY_LINK	system	\N	executed	404900	2026-08-22 20:53:25.607504+00
4377	361	RETRY_LINK	system	\N	executed	69900	2026-08-22 20:53:25.607504+00
4378	362	RETRY_LINK	system	\N	executed	295900	2026-08-22 20:53:25.607504+00
4379	363	RETRY_LINK	system	\N	executed	437600	2026-08-22 20:53:25.607504+00
4380	364	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4381	365	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4382	366	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4383	367	RETRY_LINK	system	\N	executed	242900	2026-08-22 20:53:25.607504+00
4384	368	RETRY_LINK	system	\N	executed	168000	2026-08-22 20:53:25.607504+00
4385	369	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4386	370	RETRY_LINK	system	\N	executed	336400	2026-08-22 20:53:25.607504+00
4387	371	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4388	372	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4389	373	RETRY_LINK	system	\N	executed	265000	2026-08-22 20:53:25.607504+00
4390	374	RETRY_LINK	system	\N	executed	333100	2026-08-22 20:53:25.607504+00
4391	375	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4392	377	RETRY_LINK	system	\N	executed	58800	2026-08-22 20:53:25.607504+00
4393	379	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4394	380	RETRY_LINK	system	\N	executed	151900	2026-08-22 20:53:25.607504+00
4395	381	RETRY_LINK	system	\N	executed	41600	2026-08-22 20:53:25.607504+00
4396	382	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4397	383	RETRY_LINK	system	\N	executed	484000	2026-08-22 20:53:25.607504+00
4398	384	RETRY_LINK	system	\N	executed	458900	2026-08-22 20:53:25.607504+00
4399	388	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4400	389	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4401	391	RETRY_LINK	system	\N	executed	484000	2026-08-22 20:53:25.607504+00
4402	392	RETRY_LINK	system	\N	executed	242000	2026-08-22 20:53:25.607504+00
4403	393	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4404	394	RETRY_LINK	system	\N	executed	415800	2026-08-22 20:53:25.607504+00
4405	395	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4406	397	RETRY_LINK	system	\N	executed	91200	2026-08-22 20:53:25.607504+00
4407	398	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4408	399	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4409	400	RETRY_LINK	system	\N	executed	54500	2026-08-22 20:53:25.607504+00
4410	401	RETRY_LINK	system	\N	executed	116600	2026-08-22 20:53:25.607504+00
4411	403	RETRY_LINK	system	\N	executed	239300	2026-08-22 20:53:25.607504+00
4412	405	RETRY_LINK	system	\N	executed	366500	2026-08-22 20:53:25.607504+00
4413	406	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4414	407	RETRY_LINK	system	\N	executed	440400	2026-08-22 20:53:25.607504+00
4415	408	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4416	385	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4417	386	RETRY_LINK	system	\N	executed	41300	2026-08-22 20:53:25.607504+00
4418	387	RETRY_LINK	system	\N	executed	111000	2026-08-22 20:53:25.607504+00
4419	402	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4420	409	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4421	411	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4422	412	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4423	414	RETRY_LINK	system	\N	executed	115700	2026-08-22 20:53:25.607504+00
4424	415	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4425	418	RETRY_LINK	system	\N	executed	59600	2026-08-22 20:53:25.607504+00
4426	420	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4427	421	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4428	422	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4429	423	RETRY_LINK	system	\N	executed	429900	2026-08-22 20:53:25.607504+00
4430	424	RETRY_LINK	system	\N	executed	454400	2026-08-22 20:53:25.607504+00
4431	426	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4432	427	RETRY_LINK	system	\N	executed	62300	2026-08-22 20:53:25.607504+00
4433	428	RETRY_LINK	system	\N	executed	386300	2026-08-22 20:53:25.607504+00
4434	429	RETRY_LINK	system	\N	executed	25200	2026-08-22 20:53:25.607504+00
4435	430	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4436	432	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4437	433	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4438	434	RETRY_LINK	system	\N	executed	151600	2026-08-22 20:53:25.607504+00
4439	435	RETRY_LINK	system	\N	executed	109300	2026-08-22 20:53:25.607504+00
4440	436	RETRY_LINK	system	\N	executed	52500	2026-08-22 20:53:25.607504+00
4441	437	BLOCKED	system	Customer left store. Silent retry blocked to prevent double-charge.	blocked	0	2026-08-22 20:53:25.607504+00
4442	438	RETRY_LINK	system	\N	executed	355800	2026-08-22 20:53:25.607504+00
4443	439	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4444	431	RETRY_LINK	system	\N	executed	235000	2026-08-22 20:53:25.607504+00
4445	441	RETRY_LINK	system	\N	executed	269400	2026-08-22 20:53:25.607504+00
4446	442	RETRY_LINK	system	\N	executed	317100	2026-08-22 20:53:25.607504+00
4447	443	RETRY_LINK	system	\N	executed	213600	2026-08-22 20:53:25.607504+00
4448	444	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4449	445	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4450	446	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4451	447	RETRY_LINK	system	\N	executed	210000	2026-08-22 20:53:25.607504+00
4452	448	RETRY_LINK	system	\N	executed	91100	2026-08-22 20:53:25.607504+00
4453	449	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4454	450	RETRY_LINK	system	\N	executed	124200	2026-08-22 20:53:25.607504+00
4455	451	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4456	452	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4457	453	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4458	454	RETRY_LINK	system	\N	executed	142200	2026-08-22 20:53:25.607504+00
4459	455	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4460	456	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4461	457	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4462	458	RETRY_LINK	system	\N	executed	306300	2026-08-22 20:53:25.607504+00
4463	459	RETRY_LINK	system	\N	executed	157300	2026-08-22 20:53:25.607504+00
4464	460	RETRY_LINK	system	\N	executed	465500	2026-08-22 20:53:25.607504+00
4465	461	RETRY_LINK	system	\N	executed	114300	2026-08-22 20:53:25.607504+00
4466	462	RETRY_LINK	system	\N	executed	177200	2026-08-22 20:53:25.607504+00
4467	463	RETRY_LINK	system	\N	executed	495000	2026-08-22 20:53:25.607504+00
4468	464	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4469	465	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4470	466	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4471	467	RETRY_LINK	system	\N	executed	168200	2026-08-22 20:53:25.607504+00
4472	468	RETRY_LINK	system	\N	executed	216200	2026-08-22 20:53:25.607504+00
4473	470	RETRY_LINK	system	\N	executed	358300	2026-08-22 20:53:25.607504+00
4474	471	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4475	472	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4476	473	RETRY_LINK	system	\N	executed	36200	2026-08-22 20:53:25.607504+00
4477	474	RETRY_LINK	system	\N	executed	401300	2026-08-22 20:53:25.607504+00
4478	475	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4479	476	RETRY_LINK	system	\N	executed	452000	2026-08-22 20:53:25.607504+00
4480	477	RETRY_LINK	system	\N	executed	333000	2026-08-22 20:53:25.607504+00
4481	478	RETRY_LINK	system	\N	executed	275400	2026-08-22 20:53:25.607504+00
4482	479	BLOCKED	system	Hidden fees caused abandonment. Do not retry.	blocked	0	2026-08-22 20:53:25.607504+00
4483	480	RETRY_LINK	system	\N	executed	459000	2026-08-22 20:53:25.607504+00
4484	481	RETRY_LINK	system	\N	executed	60900	2026-08-22 20:53:25.607504+00
4485	482	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4486	483	RETRY_LINK	system	\N	executed	160200	2026-08-22 20:53:25.607504+00
4487	484	RETRY_LINK	system	\N	executed	495400	2026-08-22 20:53:25.607504+00
4488	485	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4489	488	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4490	489	DEFERRED	system	\N	scheduled	0	2026-08-22 20:53:25.607504+00
4491	491	RETRY_LINK	system	\N	executed	195800	2026-08-22 20:53:25.607504+00
4492	492	RETRY_LINK	system	\N	executed	286100	2026-08-22 20:53:25.607504+00
4493	493	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4494	494	RETRY_LINK	system	\N	executed	24200	2026-08-22 20:53:25.607504+00
4495	495	BLOCKED	system	Repeated failures. Spamming will cause churn.	blocked	0	2026-08-22 20:53:25.607504+00
4496	497	RETRY_LINK	system	\N	executed	325100	2026-08-22 20:53:25.607504+00
4497	498	BLOCKED	system	Pre-debit notification < 24h. RBI compliance block.	blocked	0	2026-08-22 20:53:25.607504+00
4498	500	RETRY_LINK	system	\N	executed	154200	2026-08-22 20:53:25.607504+00
4499	486	RETRY_LINK	system	\N	executed	97600	2026-08-22 20:53:25.607504+00
4500	487	RETRY_LINK	system	\N	executed	372700	2026-08-22 20:53:25.607504+00
4501	499	RETRY_LINK	system	\N	executed	31300	2026-08-22 20:53:25.607504+00
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 7002, true);


--
-- Name: customer_payment_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_payment_history_id_seq', 1280, true);


--
-- Name: diagnoses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.diagnoses_id_seq', 4312, true);


--
-- Name: gate_decisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gate_decisions_id_seq', 8002, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 613, true);


--
-- Name: merchant_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.merchant_config_id_seq', 5, true);


--
-- Name: payment_failures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_failures_id_seq', 502, true);


--
-- Name: recovery_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recovery_actions_id_seq', 4502, true);


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
-- Name: recovery_actions recovery_actions_failure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_actions
    ADD CONSTRAINT recovery_actions_failure_id_fkey FOREIGN KEY (failure_id) REFERENCES public.payment_failures(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 9DIKROh3vgdm4y3xHEGWZxcJ1WUG4m0H2MtcJYbjIdzXKrFXmTQo6ZbhF5T7BuJ

