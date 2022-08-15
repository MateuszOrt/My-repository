--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

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
-- Name: hotele; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotele (
    nr_hotelu integer NOT NULL,
    nazwa_hotelu character varying,
    miasto character varying NOT NULL
);


ALTER TABLE public.hotele OWNER TO postgres;

--
-- Name: pokoje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pokoje (
    nr_hotelu integer NOT NULL,
    nr_pokoju integer NOT NULL,
    rodzaj_pokoju character varying,
    cena integer NOT NULL,
    status character varying DEFAULT 'wolny'::character varying,
    czy_zwierzeta character varying,
    CONSTRAINT pokoje_czy_zwierzeta_check CHECK (((czy_zwierzeta)::text = ANY (ARRAY[('tak'::character varying)::text, ('nie'::character varying)::text]))),
    CONSTRAINT pokoje_status_check CHECK (((status)::text = ANY (ARRAY[('wolny'::character varying)::text, ('zajety'::character varying)::text])))
);


ALTER TABLE public.pokoje OWNER TO postgres;

--
-- Name: apartamenty_zwierzeta; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.apartamenty_zwierzeta AS
 SELECT h.nazwa_hotelu,
    count(*) AS count
   FROM (public.pokoje p
     JOIN public.hotele h ON ((h.nr_hotelu = p.nr_hotelu)))
  WHERE (((p.rodzaj_pokoju)::text = 'Apartament'::text) AND ((p.czy_zwierzeta)::text = 'tak'::text))
  GROUP BY h.nazwa_hotelu;


ALTER TABLE public.apartamenty_zwierzeta OWNER TO postgres;

--
-- Name: goscie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goscie (
    nr_id_goscia integer NOT NULL,
    nazwisko character varying NOT NULL,
    imie character varying NOT NULL,
    nr_dowodu character varying NOT NULL,
    CONSTRAINT goscie_nr_dowodu_check CHECK (((nr_dowodu)::text ~ '^[A-Z]{3}[0-9]{6}$'::text))
);


ALTER TABLE public.goscie OWNER TO postgres;

--
-- Name: goscie_nr_id_goscia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goscie_nr_id_goscia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.goscie_nr_id_goscia_seq OWNER TO postgres;

--
-- Name: goscie_nr_id_goscia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.goscie_nr_id_goscia_seq OWNED BY public.goscie.nr_id_goscia;


--
-- Name: hotele_nr_hotelu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotele_nr_hotelu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hotele_nr_hotelu_seq OWNER TO postgres;

--
-- Name: hotele_nr_hotelu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotele_nr_hotelu_seq OWNED BY public.hotele.nr_hotelu;


--
-- Name: ilosc_pokoi_hotele; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ilosc_pokoi_hotele AS
 SELECT h.nazwa_hotelu,
    p.rodzaj_pokoju,
    count(*) AS count
   FROM (public.pokoje p
     JOIN public.hotele h ON ((h.nr_hotelu = p.nr_hotelu)))
  GROUP BY h.nazwa_hotelu, p.rodzaj_pokoju
  ORDER BY h.nazwa_hotelu;


ALTER TABLE public.ilosc_pokoi_hotele OWNER TO postgres;

--
-- Name: mieszkancy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mieszkancy (
    id_mieszkanca integer NOT NULL,
    nr_rezerwacji integer,
    nr_id_goscia integer,
    nr_hotelu integer,
    nr_pokoju integer,
    data_zameld date NOT NULL,
    data_wymeld date,
    CONSTRAINT wymeld_po_zameld CHECK ((data_wymeld > data_zameld))
);


ALTER TABLE public.mieszkancy OWNER TO postgres;

--
-- Name: mieszkancy_id_mieszkanca_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mieszkancy_id_mieszkanca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mieszkancy_id_mieszkanca_seq OWNER TO postgres;

--
-- Name: mieszkancy_id_mieszkanca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mieszkancy_id_mieszkanca_seq OWNED BY public.mieszkancy.id_mieszkanca;


--
-- Name: mieszkancy_novotel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.mieszkancy_novotel AS
 SELECT m.nr_pokoju,
    g.imie,
    g.nazwisko,
    m.nr_rezerwacji,
    m.data_zameld,
    m.data_wymeld
   FROM ((public.mieszkancy m
     JOIN public.goscie g ON ((g.nr_id_goscia = m.nr_id_goscia)))
     JOIN public.hotele h ON ((m.nr_hotelu = h.nr_hotelu)))
  WHERE ((h.nazwa_hotelu)::text = 'Novotel'::text)
  ORDER BY m.nr_pokoju;


ALTER TABLE public.mieszkancy_novotel OWNER TO postgres;

--
-- Name: rezerwacje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezerwacje (
    nr_rezerwacji integer NOT NULL,
    nazwa_hotelu character varying,
    nr_id_goscia integer,
    rodzaj_pokoju character varying,
    data_przyjazdu date NOT NULL,
    data_odjazdu date,
    czy_parking character varying DEFAULT 'nie'::character varying,
    platnosc character varying,
    zwierzeta character varying DEFAULT 'nie'::character varying,
    CONSTRAINT odjazd_po_przyjazd CHECK ((data_odjazdu > data_przyjazdu)),
    CONSTRAINT rezerwacje_czy_parking_check CHECK (((czy_parking)::text = ANY (ARRAY[('tak'::character varying)::text, ('nie'::character varying)::text]))),
    CONSTRAINT rezerwacje_platnosc_check CHECK (((platnosc)::text = ANY (ARRAY[('gotowka'::character varying)::text, ('karta'::character varying)::text]))),
    CONSTRAINT rezerwacje_zwierzeta_check CHECK (((zwierzeta)::text = ANY (ARRAY[('tak'::character varying)::text, ('nie'::character varying)::text])))
);


ALTER TABLE public.rezerwacje OWNER TO postgres;

--
-- Name: odjazdy; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.odjazdy AS
 SELECT g.nr_id_goscia,
    g.imie,
    g.nazwisko,
    r.nr_rezerwacji,
    r.nazwa_hotelu,
    r.data_odjazdu
   FROM (public.rezerwacje r
     JOIN public.goscie g ON ((g.nr_id_goscia = r.nr_id_goscia)))
  WHERE (r.data_odjazdu = CURRENT_DATE)
  ORDER BY g.nr_id_goscia;


ALTER TABLE public.odjazdy OWNER TO postgres;

--
-- Name: parking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parking (
    nr_id_goscia integer,
    miejsce integer NOT NULL,
    nr_hotelu integer NOT NULL
);


ALTER TABLE public.parking OWNER TO postgres;

--
-- Name: rezerwacje_nr_rezerwacji_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezerwacje_nr_rezerwacji_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rezerwacje_nr_rezerwacji_seq OWNER TO postgres;

--
-- Name: rezerwacje_nr_rezerwacji_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rezerwacje_nr_rezerwacji_seq OWNED BY public.rezerwacje.nr_rezerwacji;


--
-- Name: rodzaje_pokoi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rodzaje_pokoi (
    rodzaj_pokoju character varying NOT NULL
);


ALTER TABLE public.rodzaje_pokoi OWNER TO postgres;

--
-- Name: wolne_pokoje_novotel_15_06_zw; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.wolne_pokoje_novotel_15_06_zw AS
 SELECT m.nr_pokoju,
    p.rodzaj_pokoju,
    p.cena
   FROM (public.pokoje p
     JOIN public.mieszkancy m ON ((m.nr_pokoju = p.nr_pokoju)))
  WHERE ((p.nr_hotelu = 1) AND (m.data_wymeld > '2022-06-15'::date) AND ((p.czy_zwierzeta)::text = 'tak'::text));


ALTER TABLE public.wolne_pokoje_novotel_15_06_zw OWNER TO postgres;

--
-- Name: zwierzeta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zwierzeta (
    nr_id_goscia integer NOT NULL,
    zwierze character varying NOT NULL,
    ilosc integer,
    CONSTRAINT zwierzeta_zwierze_check CHECK (((zwierze)::text = ANY (ARRAY[('kot'::character varying)::text, ('pies'::character varying)::text])))
);


ALTER TABLE public.zwierzeta OWNER TO postgres;

--
-- Name: goscie nr_id_goscia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goscie ALTER COLUMN nr_id_goscia SET DEFAULT nextval('public.goscie_nr_id_goscia_seq'::regclass);


--
-- Name: hotele nr_hotelu; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotele ALTER COLUMN nr_hotelu SET DEFAULT nextval('public.hotele_nr_hotelu_seq'::regclass);


--
-- Name: mieszkancy id_mieszkanca; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mieszkancy ALTER COLUMN id_mieszkanca SET DEFAULT nextval('public.mieszkancy_id_mieszkanca_seq'::regclass);


--
-- Name: rezerwacje nr_rezerwacji; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje ALTER COLUMN nr_rezerwacji SET DEFAULT nextval('public.rezerwacje_nr_rezerwacji_seq'::regclass);


--
-- Data for Name: goscie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.goscie (nr_id_goscia, nazwisko, imie, nr_dowodu) FROM stdin;
1	Sobczak	Paulina	XSD736305
2	BÄ…k	Henryk	MLM940306
3	GĂłrski	Kazimierz	XGZ590132
4	WĂłjcik	Irena	IIX383854
5	Chmielewski	Marian	MLA533941
6	Jaworska	MaĹ‚gorzata	BKF413419
7	Duda	Ewa	JQE761741
8	Malinowski	Jakub	KAB358061
9	BrzeziĹ„ska	Jadwiga	LFS711336
10	Sawicki	Roman	GLO914510
11	Szymczak	Marcin	CLA115173
12	Baranowska	Joanna	OJW609573
13	SzczepaĹ„ski	Maciej	GHE584014
14	WrĂłbel	CzesĹ‚aw	OSV219293
15	GĂłrska	GraĹĽyna	CHA336126
16	Krawczyk	Wanda	YPU918001
17	UrbaĹ„ska	Renata	RPD531831
18	Tomaszewska	WiesĹ‚awa	UVS950740
19	Baranowska	BoĹĽena	OHJ135197
20	Malinowska	Ewelina	VLU762931
21	Krajewska	Anna	REJ330359
22	ZajÄ…c	MieczysĹ‚aw	VGQ189697
23	Przybylski	WiesĹ‚aw	LMX499852
24	Tomaszewska	Dorota	LKC241411
25	WrĂłblewski	Jerzy	AKH932092
26	Adamczyk	Magdalena	AWX134959
27	Piotrowski	WĹ‚adysĹ‚aw	HHW055845
28	WiĹ›niewski	Marek	LVO770697
29	GĹ‚owacka	StanisĹ‚awa	AML391148
30	Kubiak	Agata	FUE843274
31	Kowalski	Marian	IXV006339
32	SzymaĹ„ski	Piotr	DJO105792
33	Kowalski	StanisĹ‚aw	ZVS584013
34	Szulc	Aleksandra	YPB115581
35	Kucharski	Tomasz	AAP322541
36	Mazurek	Marcin	DUL848853
37	Baranowski	Sebastian	RPJ257314
38	Wysocka	Agata	KLW421096
39	Mazur	GraĹĽyna	LAX975738
40	Gajewski	Marcin	IOB387603
41	Sikorska	Krystyna	CPU957710
42	Kowalski	Krzysztof	JGB993477
43	Mazurek	MaĹ‚gorzata	QUT699372
44	JasiĹ„ski	Adam	JWM926241
45	Makowska	Patrycja	FOV555030
46	Adamczyk	Piotr	EJC824376
47	Wieczorek	Waldemar	UYC989410
48	Szulc	Edward	ZYH427431
49	Andrzejewski	Janusz	HTK566726
50	Nowakowska	Edyta	VBP476214
51	WoĹşniak	Joanna	GFH868958
52	Michalak	Mateusz	RKN328446
53	Sobczak	Marta	BKV577767
54	Makowski	Waldemar	JJH723185
55	JabĹ‚oĹ„ska	Marzena	OJR363982
56	Sikora	Maciej	ECW855834
57	Szewczyk	Monika	IBR207697
58	CieĹ›lak	Genowefa	CTT663547
59	Nowicka	Edyta	GNV347858
60	Malinowski	Piotr	AKJ272583
61	GĹ‚owacki	Krzysztof	WYK364525
62	Szewczyk	Andrzej	FCX546820
63	Grabowski	Mariusz	RHG167852
64	KrĂłl	Stefania	CVJ607607
65	SzczepaĹ„ski	WiesĹ‚aw	APD298375
66	Wasilewska	MaĹ‚gorzata	BSN671318
67	SzczepaĹ„ski	JĂłzef	TGZ167817
68	Kowalczyk	Mariusz	UAW064710
69	KozĹ‚owska	Janina	LVW831983
70	Kwiatkowski	Roman	VEI540516
71	KamiĹ„ska	Jadwiga	GJC053399
72	ZajÄ…c	Agnieszka	ZJS129559
73	WĹ‚odarczyk	Robert	DVX354661
74	Kowalski	Henryk	TOX404080
75	Zalewska	Kazimiera	OGQ867156
76	KaĹşmierczak	Sylwia	QOZ426489
77	Maciejewska	Dorota	SZW721533
78	Laskowski	Jacek	SUO403275
79	Sobczak	MichaĹ‚	ARV842888
80	Lis	Genowefa	RYR733093
81	CzerwiĹ„ski	MirosĹ‚aw	MTK719237
82	Gajewska	Agata	GXR099168
83	BÄ…k	Zofia	CIJ782225
84	Adamczyk	Marek	IMH207175
85	Pawlak	Agata	HYZ651650
86	Jankowski	Adam	NMK538323
87	Adamczyk	MieczysĹ‚aw	TSU374698
88	Czarnecka	Wanda	RAA421883
89	ZiĂłĹ‚kowski	Andrzej	YES693903
90	Laskowski	JarosĹ‚aw	PPV971569
91	UrbaĹ„ska	Iwona	PRD491629
92	Jakubowska	Aneta	BHP557414
93	KrĂłl	ZdzisĹ‚aw	QSS192188
94	WiĹ›niewska	Maria	GXB066433
95	Borkowski	Grzegorz	IAM825034
96	GĹ‚owacka	Maria	GIP946412
97	Pietrzak	Jakub	CIO875276
98	Piotrowska	Danuta	SUS191432
99	Chmielewski	Sebastian	AQH674777
100	Andrzejewski	Adam	ICC300561
\.


--
-- Data for Name: hotele; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotele (nr_hotelu, nazwa_hotelu, miasto) FROM stdin;
1	Novotel	Wroclaw
2	Marriott	Warszawa
3	Mercure	Poznan
4	Amber	Zakopane
5	Logos	Krakow
\.


--
-- Data for Name: mieszkancy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mieszkancy (id_mieszkanca, nr_rezerwacji, nr_id_goscia, nr_hotelu, nr_pokoju, data_zameld, data_wymeld) FROM stdin;
1	1	6	2	1	2022-05-04	2022-06-19
2	2	67	3	1	2022-05-05	2022-06-13
3	3	90	4	1	2022-05-15	2022-06-08
4	4	80	5	1	2022-05-12	2022-06-16
5	5	30	1	2	2022-05-25	2022-06-20
6	6	22	2	2	2022-05-04	2022-06-14
7	7	5	3	2	2022-05-06	2022-06-18
8	8	25	4	2	2022-05-08	2022-06-28
9	9	64	5	2	2022-05-29	2022-06-28
10	10	28	1	3	2022-05-26	2022-06-17
11	11	13	2	3	2022-05-18	2022-06-03
12	12	35	3	3	2022-05-19	2022-06-12
13	13	71	4	3	2022-05-26	2022-06-29
14	14	19	5	3	2022-05-18	2022-06-12
15	15	55	1	4	2022-05-08	2022-06-15
16	16	50	2	4	2022-05-18	2022-06-11
17	17	69	3	4	2022-05-18	2022-06-11
18	18	17	4	4	2022-05-20	2022-06-16
19	19	3	5	4	2022-05-13	2022-06-23
20	20	31	1	5	2022-05-16	2022-06-27
21	21	62	2	5	2022-05-28	2022-06-20
22	22	36	3	5	2022-05-28	2022-06-13
23	23	66	4	5	2022-05-14	2022-06-27
24	24	38	5	5	2022-05-30	2022-06-05
25	25	84	1	6	2022-05-12	2022-06-25
26	26	88	2	6	2022-05-12	2022-06-15
27	27	34	3	6	2022-05-26	2022-06-11
28	28	68	4	6	2022-05-12	2022-06-20
29	29	74	5	6	2022-05-08	2022-06-19
30	30	52	1	7	2022-05-05	2022-06-18
31	31	21	2	7	2022-05-02	2022-06-27
32	32	76	3	7	2022-05-08	2022-06-05
33	33	100	4	7	2022-05-09	2022-06-05
34	34	8	5	7	2022-05-13	2022-06-01
35	35	65	1	8	2022-05-13	2022-06-28
36	36	60	2	8	2022-05-21	2022-06-08
37	37	41	3	8	2022-05-05	2022-06-22
38	38	23	4	8	2022-05-16	2022-06-09
39	39	94	5	8	2022-05-12	2022-06-15
40	40	58	1	9	2022-05-23	2022-06-20
41	41	27	2	9	2022-05-02	2022-06-04
42	42	45	3	9	2022-05-30	2022-06-20
43	43	51	4	9	2022-05-01	2022-06-20
44	44	2	5	9	2022-05-01	2022-06-05
45	45	85	1	10	2022-05-04	2022-06-06
46	46	75	2	10	2022-05-28	2022-06-07
47	47	9	3	10	2022-05-07	2022-06-07
48	48	91	4	10	2022-05-04	2022-06-04
49	49	44	5	10	2022-05-13	2022-06-07
50	50	99	1	11	2022-05-27	2022-06-15
51	51	11	2	11	2022-05-07	2022-06-02
52	52	16	3	11	2022-05-09	2022-06-15
53	53	70	4	11	2022-05-05	2022-06-20
54	54	63	5	11	2022-05-19	2022-06-27
55	55	98	1	12	2022-05-29	2022-06-24
56	56	43	2	12	2022-05-19	2022-06-26
57	57	83	3	12	2022-05-06	2022-06-09
58	58	49	4	12	2022-05-07	2022-06-20
59	59	32	5	12	2022-05-05	2022-06-15
60	60	18	1	13	2022-05-09	2022-06-07
61	61	77	2	13	2022-05-28	2022-06-12
62	62	39	3	13	2022-05-03	2022-06-05
63	63	1	4	13	2022-05-07	2022-06-05
64	64	79	5	13	2022-05-08	2022-06-20
65	65	4	1	14	2022-05-15	2022-06-16
66	66	57	2	14	2022-05-29	2022-06-06
67	67	56	3	14	2022-05-06	2022-06-19
68	68	47	4	14	2022-05-02	2022-06-28
69	69	81	5	14	2022-05-25	2022-06-18
70	70	78	1	15	2022-05-25	2022-06-06
71	71	72	2	15	2022-05-05	2022-06-22
72	72	24	3	15	2022-05-20	2022-06-16
73	73	96	4	15	2022-05-28	2022-06-18
74	74	86	5	15	2022-05-19	2022-06-24
75	75	29	1	16	2022-05-21	2022-06-22
76	76	89	2	16	2022-05-24	2022-06-25
77	77	40	3	16	2022-05-08	2022-06-20
78	78	42	4	16	2022-05-28	2022-06-08
79	79	33	5	16	2022-05-28	2022-06-20
80	80	73	1	17	2022-05-02	2022-06-27
81	81	87	2	17	2022-05-18	2022-06-27
82	82	59	3	17	2022-05-12	2022-06-01
83	83	93	4	17	2022-05-22	2022-06-29
84	84	10	5	17	2022-05-07	2022-06-10
85	85	26	1	18	2022-05-11	2022-06-08
86	86	46	2	18	2022-05-15	2022-06-25
87	87	12	3	18	2022-05-07	2022-06-15
88	88	97	4	18	2022-05-24	2022-06-29
89	89	37	5	18	2022-05-04	2022-06-11
90	90	92	1	19	2022-05-10	2022-06-24
91	91	14	2	19	2022-05-18	2022-06-10
92	92	20	3	19	2022-05-25	2022-06-15
93	93	54	4	19	2022-05-05	2022-06-23
94	94	61	5	19	2022-05-15	2022-06-27
95	95	95	1	20	2022-05-12	2022-06-26
96	96	82	2	20	2022-05-11	2022-06-16
97	97	48	3	20	2022-05-13	2022-06-09
98	98	15	4	20	2022-05-22	2022-06-21
99	99	7	5	20	2022-05-26	2022-06-24
100	100	53	1	21	2022-05-15	2022-06-09
\.


--
-- Data for Name: parking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parking (nr_id_goscia, miejsce, nr_hotelu) FROM stdin;
2	6	2
5	7	1
7	11	2
15	17	1
20	22	1
23	31	4
25	27	1
26	36	5
27	31	2
28	36	4
42	46	2
45	47	1
46	56	5
48	56	4
56	66	5
60	62	1
63	71	4
65	67	1
66	76	5
69	75	3
71	81	5
72	76	2
78	86	4
79	85	3
81	91	5
82	86	2
83	91	4
84	90	3
85	87	1
87	91	2
88	96	4
89	95	3
92	96	2
97	101	2
99	105	3
77	81	2
62	66	2
51	61	5
41	51	5
47	51	2
43	51	4
38	46	4
64	70	3
86	96	5
68	76	4
40	42	1
32	36	2
44	50	3
29	35	3
39	45	3
\.


--
-- Data for Name: pokoje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pokoje (nr_hotelu, nr_pokoju, rodzaj_pokoju, cena, status, czy_zwierzeta) FROM stdin;
1	2	1-osobowy	250	zajety	nie
2	2	1-osobowy	250	zajety	nie
3	2	1-osobowy	250	zajety	nie
4	2	2-osobowy	400	zajety	nie
5	2	2-osobowy	400	zajety	nie
1	3	1-osobowy	250	zajety	tak
1	1	1-osobowy	250	wolny	tak
2	3	2-osobowy	400	wolny	nie
3	3	1-osobowy	250	zajety	tak
4	3	3-osobowy	500	zajety	nie
5	3	2-osobowy	400	zajety	nie
1	4	3-osobowy	500	zajety	nie
2	4	2-osobowy	400	zajety	nie
3	4	2-osobowy	400	zajety	nie
4	4	2-osobowy	400	zajety	nie
5	4	3-osobowy	500	zajety	nie
1	5	2-osobowy	400	zajety	nie
2	5	1-osobowy	250	zajety	nie
3	5	3-osobowy	500	zajety	tak
4	5	Apartament	1000	zajety	nie
5	5	1-osobowy	250	zajety	tak
1	6	1-osobowy	250	zajety	nie
2	6	1-osobowy	250	zajety	nie
3	6	Apartament	1000	zajety	nie
4	6	2-osobowy	400	zajety	nie
5	6	1-osobowy	250	zajety	tak
1	7	1-osobowy	250	zajety	nie
2	7	2-osobowy	400	zajety	nie
3	7	3-osobowy	500	zajety	tak
2	1	1-osobowy	250	zajety	tak
4	7	Apartament	1000	zajety	nie
5	7	Apartament	1000	wolny	nie
3	1	3-osobowy	500	zajety	tak
4	1	Apartament	1000	zajety	tak
5	1	Apartament	1000	zajety	tak
1	8	3-osobowy	500	zajety	nie
2	8	2-osobowy	400	zajety	tak
3	20	Apartament	1000	zajety	nie
4	20	2-osobowy	400	zajety	nie
5	20	3-osobowy	500	zajety	nie
3	8	3-osobowy	500	zajety	nie
4	8	Apartament	1000	zajety	tak
5	8	2-osobowy	400	zajety	tak
1	9	3-osobowy	500	zajety	tak
2	9	2-osobowy	400	zajety	tak
3	9	Apartament	1000	zajety	nie
4	9	1-osobowy	250	zajety	tak
5	9	3-osobowy	500	zajety	tak
1	10	Apartament	1000	zajety	nie
2	10	2-osobowy	400	zajety	nie
3	10	Apartament	1000	zajety	tak
4	10	2-osobowy	400	zajety	nie
5	10	Apartament	1000	zajety	nie
1	11	1-osobowy	250	zajety	tak
2	11	2-osobowy	400	wolny	tak
3	11	3-osobowy	500	zajety	nie
4	11	3-osobowy	500	zajety	nie
5	11	3-osobowy	500	zajety	tak
1	12	Apartament	1000	zajety	tak
2	12	3-osobowy	500	zajety	nie
3	12	2-osobowy	400	zajety	tak
4	12	3-osobowy	500	zajety	tak
5	12	Apartament	1000	zajety	nie
1	13	1-osobowy	250	zajety	nie
2	13	3-osobowy	500	zajety	nie
3	13	2-osobowy	400	zajety	tak
4	13	Apartament	1000	zajety	nie
5	13	2-osobowy	400	zajety	tak
1	14	1-osobowy	250	zajety	nie
2	14	Apartament	1000	zajety	nie
3	14	2-osobowy	400	zajety	nie
4	14	2-osobowy	400	zajety	tak
5	14	1-osobowy	250	zajety	nie
1	15	1-osobowy	250	zajety	nie
2	15	Apartament	1000	zajety	nie
3	15	2-osobowy	400	zajety	nie
4	15	3-osobowy	500	zajety	nie
5	15	3-osobowy	500	zajety	tak
1	16	Apartament	1000	zajety	nie
2	16	1-osobowy	250	zajety	nie
3	16	Apartament	1000	zajety	tak
4	16	Apartament	1000	zajety	nie
5	16	2-osobowy	400	zajety	nie
1	17	Apartament	1000	zajety	nie
2	17	2-osobowy	400	zajety	nie
3	17	2-osobowy	400	wolny	nie
4	17	Apartament	1000	zajety	nie
5	17	Apartament	1000	zajety	nie
1	18	2-osobowy	400	zajety	nie
2	18	3-osobowy	500	zajety	tak
3	18	2-osobowy	400	zajety	nie
4	18	3-osobowy	500	zajety	nie
5	18	1-osobowy	250	zajety	nie
1	19	3-osobowy	500	zajety	tak
2	19	1-osobowy	250	zajety	tak
3	19	2-osobowy	400	zajety	nie
4	19	2-osobowy	400	zajety	nie
5	19	3-osobowy	500	zajety	nie
1	20	2-osobowy	400	zajety	nie
2	20	Apartament	1000	zajety	nie
\.


--
-- Data for Name: rezerwacje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezerwacje (nr_rezerwacji, nazwa_hotelu, nr_id_goscia, rodzaj_pokoju, data_przyjazdu, data_odjazdu, czy_parking, platnosc, zwierzeta) FROM stdin;
2	Marriott	2	Apartament	2022-05-29	2022-06-11	tak	karta	nie
4	Mercure	4	1-osobowy	2022-05-09	2022-06-25	nie	karta	nie
5	Novotel	5	2-osobowy	2022-05-28	2022-06-17	tak	gotowka	nie
6	Logos	6	1-osobowy	2022-05-16	2022-06-25	nie	gotowka	nie
7	Marriott	7	1-osobowy	2022-05-06	2022-06-21	tak	gotowka	nie
8	Amber	8	1-osobowy	2022-05-09	2022-06-14	nie	gotowka	nie
9	Mercure	9	3-osobowy	2022-05-30	2022-06-07	nie	karta	nie
11	Logos	11	3-osobowy	2022-05-15	2022-06-22	nie	karta	nie
13	Amber	13	3-osobowy	2022-05-07	2022-06-16	nie	gotowka	nie
14	Mercure	14	2-osobowy	2022-05-07	2022-06-27	nie	gotowka	nie
15	Novotel	15	1-osobowy	2022-05-19	2022-06-03	tak	karta	nie
16	Logos	16	2-osobowy	2022-05-11	2022-06-29	nie	karta	nie
17	Marriott	17	1-osobowy	2022-05-30	2022-06-04	nie	gotowka	nie
18	Amber	18	Apartament	2022-05-08	2022-06-09	nie	gotowka	nie
19	Mercure	19	2-osobowy	2022-05-28	2022-06-29	nie	gotowka	nie
20	Novotel	20	2-osobowy	2022-05-10	2022-06-04	tak	karta	nie
21	Logos	21	2-osobowy	2022-05-29	2022-06-16	nie	karta	nie
23	Amber	23	3-osobowy	2022-05-27	2022-06-29	tak	karta	nie
25	Novotel	25	Apartament	2022-05-23	2022-06-11	tak	gotowka	nie
26	Logos	26	Apartament	2022-05-05	2022-06-18	tak	karta	nie
27	Marriott	27	Apartament	2022-05-02	2022-06-10	tak	karta	nie
28	Amber	28	1-osobowy	2022-05-01	2022-06-29	tak	karta	nie
30	Novotel	30	2-osobowy	2022-05-24	2022-06-10	nie	karta	nie
31	Logos	31	1-osobowy	2022-05-06	2022-06-04	nie	karta	nie
33	Amber	33	3-osobowy	2022-05-22	2022-06-05	nie	gotowka	nie
34	Mercure	34	2-osobowy	2022-05-16	2022-06-05	nie	karta	nie
35	Novotel	35	Apartament	2022-05-05	2022-06-02	nie	gotowka	nie
37	Marriott	37	1-osobowy	2022-05-22	2022-06-12	nie	gotowka	nie
42	Marriott	42	1-osobowy	2022-05-05	2022-06-05	tak	gotowka	nie
45	Novotel	45	2-osobowy	2022-05-02	2022-06-01	tak	karta	nie
46	Logos	46	Apartament	2022-05-12	2022-06-22	tak	gotowka	nie
48	Amber	48	Apartament	2022-05-17	2022-06-09	tak	gotowka	nie
49	Mercure	49	3-osobowy	2022-05-27	2022-06-25	nie	gotowka	nie
52	Marriott	52	Apartament	2022-05-09	2022-06-20	nie	gotowka	nie
53	Amber	53	1-osobowy	2022-05-18	2022-06-08	nie	gotowka	nie
56	Logos	56	1-osobowy	2022-05-10	2022-06-13	tak	karta	nie
59	Mercure	59	Apartament	2022-05-23	2022-06-18	nie	gotowka	nie
60	Novotel	60	3-osobowy	2022-05-19	2022-06-24	tak	karta	nie
61	Logos	61	2-osobowy	2022-05-05	2022-06-18	nie	gotowka	nie
63	Amber	63	Apartament	2022-05-27	2022-06-14	tak	gotowka	nie
65	Novotel	65	Apartament	2022-05-26	2022-06-05	tak	karta	nie
66	Logos	66	3-osobowy	2022-05-28	2022-06-28	tak	karta	nie
67	Marriott	67	3-osobowy	2022-05-10	2022-06-21	nie	karta	nie
69	Mercure	69	3-osobowy	2022-05-03	2022-06-17	tak	karta	nie
70	Novotel	70	1-osobowy	2022-05-02	2022-06-06	nie	gotowka	nie
71	Logos	71	2-osobowy	2022-05-10	2022-06-12	tak	karta	nie
72	Marriott	72	2-osobowy	2022-05-19	2022-06-24	tak	gotowka	nie
73	Amber	73	3-osobowy	2022-05-25	2022-06-28	nie	gotowka	nie
75	Novotel	75	Apartament	2022-05-08	2022-06-06	nie	gotowka	nie
76	Logos	76	Apartament	2022-05-23	2022-06-21	nie	gotowka	nie
78	Amber	78	Apartament	2022-05-30	2022-06-06	tak	gotowka	nie
79	Mercure	79	3-osobowy	2022-05-06	2022-06-18	tak	karta	nie
80	Novotel	80	1-osobowy	2022-05-01	2022-06-07	nie	gotowka	nie
81	Logos	81	Apartament	2022-05-09	2022-06-05	tak	karta	nie
82	Marriott	82	2-osobowy	2022-05-17	2022-06-01	tak	gotowka	nie
83	Amber	83	1-osobowy	2022-05-06	2022-06-09	tak	karta	nie
84	Mercure	84	Apartament	2022-05-03	2022-06-11	tak	karta	nie
85	Novotel	85	Apartament	2022-05-02	2022-06-23	tak	gotowka	nie
87	Marriott	87	3-osobowy	2022-05-13	2022-06-04	tak	gotowka	nie
88	Amber	88	2-osobowy	2022-05-20	2022-06-14	tak	gotowka	nie
89	Mercure	89	3-osobowy	2022-05-26	2022-06-18	tak	karta	nie
92	Marriott	92	Apartament	2022-05-23	2022-06-23	tak	gotowka	nie
93	Amber	93	2-osobowy	2022-05-27	2022-06-12	nie	gotowka	nie
94	Mercure	94	1-osobowy	2022-05-27	2022-06-08	nie	karta	nie
95	Novotel	95	3-osobowy	2022-05-25	2022-06-04	nie	gotowka	nie
96	Logos	96	3-osobowy	2022-05-19	2022-06-08	nie	gotowka	nie
97	Marriott	97	2-osobowy	2022-05-09	2022-06-29	tak	gotowka	nie
98	Amber	98	1-osobowy	2022-05-01	2022-06-15	nie	karta	nie
99	Mercure	99	Apartament	2022-05-11	2022-06-05	tak	gotowka	nie
100	Novotel	100	3-osobowy	2022-05-13	2022-06-21	nie	karta	nie
77	Marriott	77	Apartament	2022-05-05	2022-06-03	tak	karta	tak
57	Marriott	57	2-osobowy	2022-05-29	2022-06-16	nie	gotowka	tak
62	Marriott	62	3-osobowy	2022-05-05	2022-06-26	tak	gotowka	tak
51	Logos	51	2-osobowy	2022-05-19	2022-06-18	tak	gotowka	tak
41	Logos	41	1-osobowy	2022-05-07	2022-06-21	tak	gotowka	tak
12	Marriott	12	3-osobowy	2022-05-20	2022-06-10	nie	karta	tak
22	Marriott	22	3-osobowy	2022-05-01	2022-06-14	nie	gotowka	tak
54	Mercure	54	3-osobowy	2022-05-08	2022-06-28	nie	gotowka	tak
47	Marriott	47	3-osobowy	2022-05-24	2022-06-25	tak	gotowka	tak
36	Logos	36	3-osobowy	2022-05-05	2022-06-15	nie	karta	tak
50	Novotel	50	1-osobowy	2022-05-17	2022-06-21	nie	gotowka	tak
55	Novotel	55	1-osobowy	2022-05-03	2022-06-03	nie	karta	tak
1	Logos	1	1-osobowy	2022-05-16	2022-06-09	nie	karta	tak
43	Amber	43	Apartament	2022-05-25	2022-06-12	tak	karta	tak
38	Amber	38	Apartament	2022-05-06	2022-06-06	tak	gotowka	tak
64	Mercure	64	1-osobowy	2022-05-25	2022-06-13	tak	gotowka	tak
86	Logos	86	2-osobowy	2022-05-24	2022-06-04	tak	gotowka	tak
68	Amber	68	3-osobowy	2022-05-21	2022-06-03	tak	gotowka	tak
40	Novotel	40	3-osobowy	2022-05-09	2022-06-28	tak	gotowka	tak
32	Marriott	32	Apartament	2022-05-13	2022-06-09	tak	gotowka	tak
74	Mercure	74	1-osobowy	2022-05-04	2022-06-13	nie	karta	tak
58	Amber	58	3-osobowy	2022-05-02	2022-06-22	nie	karta	tak
44	Mercure	44	3-osobowy	2022-05-30	2022-06-21	tak	karta	tak
10	Novotel	10	3-osobowy	2022-05-20	2022-06-04	nie	gotowka	tak
3	Amber	3	Apartament	2022-05-09	2022-06-10	nie	gotowka	tak
24	Mercure	24	1-osobowy	2022-05-12	2022-06-25	nie	karta	tak
90	Novotel	90	Apartament	2022-05-06	2022-06-14	nie	karta	tak
29	Mercure	29	1-osobowy	2022-05-18	2022-06-23	tak	gotowka	tak
91	Logos	91	1-osobowy	2022-05-26	2022-06-03	nie	gotowka	tak
39	Mercure	39	2-osobowy	2022-05-21	2022-06-13	tak	gotowka	tak
\.


--
-- Data for Name: rodzaje_pokoi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rodzaje_pokoi (rodzaj_pokoju) FROM stdin;
1-osobowy
2-osobowy
3-osobowy
Apartament
\.


--
-- Data for Name: zwierzeta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zwierzeta (nr_id_goscia, zwierze, ilosc) FROM stdin;
77	pies	5
57	kot	1
62	kot	1
51	kot	1
41	kot	2
12	pies	4
22	pies	5
54	kot	3
36	kot	2
36	pies	1
50	pies	1
55	pies	4
1	pies	1
43	pies	3
38	kot	2
64	pies	2
86	kot	2
68	pies	2
40	pies	3
32	pies	4
74	kot	1
58	pies	2
44	pies	3
10	pies	2
3	kot	2
24	kot	2
90	kot	3
29	pies	5
29	kot	1
39	pies	5
\.


--
-- Name: goscie_nr_id_goscia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goscie_nr_id_goscia_seq', 100, true);


--
-- Name: hotele_nr_hotelu_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotele_nr_hotelu_seq', 5, true);


--
-- Name: mieszkancy_id_mieszkanca_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mieszkancy_id_mieszkanca_seq', 100, true);


--
-- Name: rezerwacje_nr_rezerwacji_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezerwacje_nr_rezerwacji_seq', 100, true);


--
-- Name: goscie goscie_nr_dowodu_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goscie
    ADD CONSTRAINT goscie_nr_dowodu_key UNIQUE (nr_dowodu);


--
-- Name: goscie goscie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goscie
    ADD CONSTRAINT goscie_pkey PRIMARY KEY (nr_id_goscia);


--
-- Name: hotele hotele_nazwa_hotelu_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotele
    ADD CONSTRAINT hotele_nazwa_hotelu_key UNIQUE (nazwa_hotelu);


--
-- Name: hotele hotele_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotele
    ADD CONSTRAINT hotele_pkey PRIMARY KEY (nr_hotelu);


--
-- Name: mieszkancy mieszkancy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mieszkancy
    ADD CONSTRAINT mieszkancy_pkey PRIMARY KEY (id_mieszkanca);


--
-- Name: parking parking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking
    ADD CONSTRAINT parking_pkey PRIMARY KEY (nr_hotelu, miejsce);


--
-- Name: pokoje pokoje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokoje
    ADD CONSTRAINT pokoje_pkey PRIMARY KEY (nr_hotelu, nr_pokoju);


--
-- Name: rezerwacje rezerwacje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT rezerwacje_pkey PRIMARY KEY (nr_rezerwacji);


--
-- Name: rodzaje_pokoi rodzaje_pokoi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rodzaje_pokoi
    ADD CONSTRAINT rodzaje_pokoi_pkey PRIMARY KEY (rodzaj_pokoju);


--
-- Name: zwierzeta zwierzeta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zwierzeta
    ADD CONSTRAINT zwierzeta_pkey PRIMARY KEY (nr_id_goscia, zwierze);


--
-- Name: mieszkancy mieszkancy_nr_hotelu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mieszkancy
    ADD CONSTRAINT mieszkancy_nr_hotelu_fkey FOREIGN KEY (nr_hotelu) REFERENCES public.hotele(nr_hotelu);


--
-- Name: mieszkancy mieszkancy_nr_id_goscia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mieszkancy
    ADD CONSTRAINT mieszkancy_nr_id_goscia_fkey FOREIGN KEY (nr_id_goscia) REFERENCES public.goscie(nr_id_goscia);


--
-- Name: mieszkancy mieszkancy_nr_rezerwacji_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mieszkancy
    ADD CONSTRAINT mieszkancy_nr_rezerwacji_fkey FOREIGN KEY (nr_rezerwacji) REFERENCES public.rezerwacje(nr_rezerwacji);


--
-- Name: parking parking_nr_hotelu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking
    ADD CONSTRAINT parking_nr_hotelu_fkey FOREIGN KEY (nr_hotelu) REFERENCES public.hotele(nr_hotelu);


--
-- Name: parking parking_nr_id_goscia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking
    ADD CONSTRAINT parking_nr_id_goscia_fkey FOREIGN KEY (nr_id_goscia) REFERENCES public.goscie(nr_id_goscia);


--
-- Name: pokoje pokoje_nr_hotelu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokoje
    ADD CONSTRAINT pokoje_nr_hotelu_fkey FOREIGN KEY (nr_hotelu) REFERENCES public.hotele(nr_hotelu);


--
-- Name: pokoje pokoje_rodzaj_pokoju_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokoje
    ADD CONSTRAINT pokoje_rodzaj_pokoju_fkey FOREIGN KEY (rodzaj_pokoju) REFERENCES public.rodzaje_pokoi(rodzaj_pokoju);


--
-- Name: rezerwacje rezerwacje_nazwa_hotelu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT rezerwacje_nazwa_hotelu_fkey FOREIGN KEY (nazwa_hotelu) REFERENCES public.hotele(nazwa_hotelu);


--
-- Name: rezerwacje rezerwacje_nr_id_goscia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT rezerwacje_nr_id_goscia_fkey FOREIGN KEY (nr_id_goscia) REFERENCES public.goscie(nr_id_goscia);


--
-- Name: rezerwacje rezerwacje_rodzaj_pokoju_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT rezerwacje_rodzaj_pokoju_fkey FOREIGN KEY (rodzaj_pokoju) REFERENCES public.rodzaje_pokoi(rodzaj_pokoju);


--
-- Name: zwierzeta zwierzeta_nr_id_goscia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zwierzeta
    ADD CONSTRAINT zwierzeta_nr_id_goscia_fkey FOREIGN KEY (nr_id_goscia) REFERENCES public.goscie(nr_id_goscia);


--
-- PostgreSQL database dump complete
--

