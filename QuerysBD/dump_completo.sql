--
-- PostgreSQL database dump
--

\restrict GaKmVzq3z3ouJ9vTfKgChhxqR6plS1hhdIdjHltnSt4hvtOfMOytFRL7tEYKEoG

-- Dumped from database version 17.10 (Debian 17.10-1.pgdg13+1)
-- Dumped by pg_dump version 17.10 (Debian 17.10-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: c_p; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.c_p (
    id integer NOT NULL,
    mencion character varying(255),
    posicion integer,
    concurso_id integer,
    participante_id integer
);


--
-- Name: c_p_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.c_p_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: c_p_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.c_p_id_seq OWNED BY public.c_p.id;


--
-- Name: concurso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.concurso (
    id_concurso integer NOT NULL,
    nombre character varying(255) NOT NULL,
    fecha date NOT NULL,
    categoria character varying(255),
    tema character varying(255)
);


--
-- Name: concurso_id_concurso_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.concurso_id_concurso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: concurso_id_concurso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.concurso_id_concurso_seq OWNED BY public.concurso.id_concurso;


--
-- Name: e_p; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.e_p (
    id integer NOT NULL,
    exposicion_id integer,
    participante_id integer,
    obra_id integer,
    numero_obra integer
);


--
-- Name: e_p_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.e_p_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: e_p_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.e_p_id_seq OWNED BY public.e_p.id;


--
-- Name: en_p; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.en_p (
    id integer NOT NULL,
    encuentro_id integer,
    participante_id integer
);


--
-- Name: en_p_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.en_p_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: en_p_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.en_p_id_seq OWNED BY public.en_p.id;


--
-- Name: encuentro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.encuentro (
    id_encuentro integer NOT NULL,
    nombre character varying(255) NOT NULL,
    fecha date NOT NULL,
    lugar character varying(255)
);


--
-- Name: encuentro_id_encuentro_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.encuentro_id_encuentro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: encuentro_id_encuentro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.encuentro_id_encuentro_seq OWNED BY public.encuentro.id_encuentro;


--
-- Name: estado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estado (
    id_estado integer NOT NULL,
    nombre character varying(255) NOT NULL
);


--
-- Name: estado_id_estado_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.estado_id_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estado_id_estado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.estado_id_estado_seq OWNED BY public.estado.id_estado;


--
-- Name: exposicion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exposicion (
    id_expo integer NOT NULL,
    nombre character varying(255) NOT NULL,
    fecha date NOT NULL,
    tipo character varying(255) NOT NULL,
    lugar character varying(255),
    tema character varying(255)
);


--
-- Name: exposicion_id_expo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exposicion_id_expo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exposicion_id_expo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exposicion_id_expo_seq OWNED BY public.exposicion.id_expo;


--
-- Name: obra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.obra (
    id_obra integer NOT NULL,
    numero_obra character varying(50),
    titulo character varying(255) NOT NULL,
    tecnica character varying(255),
    ancho numeric(10,2),
    alto numeric(10,2),
    anio integer,
    tema character varying(255),
    estilo character varying(255),
    ubicacion character varying(255),
    observacion text,
    participante_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: obra_id_obra_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.obra_id_obra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: obra_id_obra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.obra_id_obra_seq OWNED BY public.obra.id_obra;


--
-- Name: participante; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participante (
    id_participante integer NOT NULL,
    nombre character varying(255) NOT NULL,
    cedula character varying(255),
    fecha_nacimiento date NOT NULL,
    correo character varying(255) NOT NULL,
    ciudad character varying(255) NOT NULL,
    instagram character varying(255),
    estado_id integer
);


--
-- Name: participante_id_participante_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participante_id_participante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participante_id_participante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participante_id_participante_seq OWNED BY public.participante.id_participante;


--
-- Name: t_p; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.t_p (
    id integer NOT NULL,
    taller_id integer,
    participante_id integer
);


--
-- Name: t_p_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.t_p_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: t_p_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.t_p_id_seq OWNED BY public.t_p.id;


--
-- Name: taller; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taller (
    id_taller integer NOT NULL,
    nombre character varying(255) NOT NULL,
    fecha date NOT NULL,
    lugar character varying(255)
);


--
-- Name: taller_id_taller_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taller_id_taller_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taller_id_taller_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taller_id_taller_seq OWNED BY public.taller.id_taller;


--
-- Name: telefono; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.telefono (
    id_telefono integer NOT NULL,
    numero_telefonico character varying(255) NOT NULL,
    participante_id integer
);


--
-- Name: telefono_id_telefono_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.telefono_id_telefono_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: telefono_id_telefono_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.telefono_id_telefono_seq OWNED BY public.telefono.id_telefono;


--
-- Name: c_p id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.c_p ALTER COLUMN id SET DEFAULT nextval('public.c_p_id_seq'::regclass);


--
-- Name: concurso id_concurso; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concurso ALTER COLUMN id_concurso SET DEFAULT nextval('public.concurso_id_concurso_seq'::regclass);


--
-- Name: e_p id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_p ALTER COLUMN id SET DEFAULT nextval('public.e_p_id_seq'::regclass);


--
-- Name: en_p id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.en_p ALTER COLUMN id SET DEFAULT nextval('public.en_p_id_seq'::regclass);


--
-- Name: encuentro id_encuentro; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encuentro ALTER COLUMN id_encuentro SET DEFAULT nextval('public.encuentro_id_encuentro_seq'::regclass);


--
-- Name: estado id_estado; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estado ALTER COLUMN id_estado SET DEFAULT nextval('public.estado_id_estado_seq'::regclass);


--
-- Name: exposicion id_expo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exposicion ALTER COLUMN id_expo SET DEFAULT nextval('public.exposicion_id_expo_seq'::regclass);


--
-- Name: obra id_obra; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obra ALTER COLUMN id_obra SET DEFAULT nextval('public.obra_id_obra_seq'::regclass);


--
-- Name: participante id_participante; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participante ALTER COLUMN id_participante SET DEFAULT nextval('public.participante_id_participante_seq'::regclass);


--
-- Name: t_p id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.t_p ALTER COLUMN id SET DEFAULT nextval('public.t_p_id_seq'::regclass);


--
-- Name: taller id_taller; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taller ALTER COLUMN id_taller SET DEFAULT nextval('public.taller_id_taller_seq'::regclass);


--
-- Name: telefono id_telefono; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telefono ALTER COLUMN id_telefono SET DEFAULT nextval('public.telefono_id_telefono_seq'::regclass);


--
-- Data for Name: c_p; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.c_p (id, mencion, posicion, concurso_id, participante_id) FROM stdin;
1	\N	2	1	1
2	\N	\N	1	11
3	\N	\N	1	65
4	\N	\N	1	116
5	\N	\N	1	119
6	\N	3	1	130
7	\N	1	1	132
8	\N	\N	1	181
9	\N	\N	1	186
10	\N	\N	1	194
11	\N	\N	2	2
12	\N	\N	2	14
13	\N	\N	2	20
14	\N	1	2	33
15	\N	\N	2	35
16	\N	\N	2	46
17	\N	\N	2	51
18	\N	\N	2	59
19	\N	\N	2	62
20	\N	\N	2	73
21	\N	\N	2	74
22	\N	\N	2	78
23	\N	\N	2	80
24	\N	\N	2	92
25	\N	\N	2	97
26	\N	\N	2	99
27	\N	\N	2	108
28	\N	\N	2	135
29	\N	\N	2	150
30	\N	\N	2	177
31	\N	2	2	191
32	\N	\N	2	192
33	\N	3	2	198
34	\N	\N	2	229
35	\N	\N	2	235
36	\N	\N	2	265
37	\N	\N	2	284
38	\N	\N	2	295
39	\N	\N	3	4
40	\N	\N	3	7
41	\N	3	3	18
42	\N	\N	3	94
43	\N	\N	3	96
44	\N	\N	3	118
45	\N	3	3	149
46	\N	\N	3	170
47	\N	\N	3	219
48	\N	\N	3	222
49	\N	2	3	246
50	\N	1	3	251
51	\N	\N	3	272
52	\N	\N	4	1
53	\N	\N	4	58
54	\N	1	4	65
55	\N	\N	4	123
56	\N	\N	4	125
57	\N	\N	4	130
58	\N	\N	4	132
59	\N	3	4	185
60	\N	\N	4	186
61	\N	\N	4	218
62	\N	\N	4	231
63	\N	2	4	274
64	Mención Dibujo	\N	4	279
65	\N	\N	4	282
66	\N	\N	4	285
67	\N	\N	5	3
68	Mención Historia	\N	5	19
69	\N	\N	5	20
70	\N	3	5	45
71	\N	\N	5	46
72	Mención Dibujo	\N	5	51
73	\N	\N	5	62
74	\N	\N	5	73
75	\N	\N	5	86
76	\N	\N	5	92
77	\N	2	5	110
78	\N	\N	5	135
79	\N	\N	5	140
80	\N	\N	5	146
81	\N	\N	5	176
82	\N	\N	5	178
83	\N	1	5	183
84	\N	\N	5	223
85	\N	\N	5	225
86	\N	\N	5	240
87	\N	\N	5	283
88	\N	\N	5	295
89	\N	\N	5	300
90	Mención Dibujo	\N	6	102
91	\N	\N	6	118
92	\N	1	6	129
93	\N	\N	6	164
94	\N	\N	6	207
95	\N	2	6	244
96	Mención Historia	\N	6	251
97	\N	\N	6	293
99	\N	\N	7	38
100	\N	\N	7	61
101	\N	\N	7	75
102	\N	\N	7	119
103	\N	2	7	141
104	\N	\N	7	153
105	\N	3	7	166
106	\N	\N	7	167
107	\N	\N	7	187
108	\N	\N	7	191
109	\N	\N	7	208
110	\N	1	7	255
111	\N	\N	7	261
112	\N	\N	8	51
113	\N	\N	8	92
114	\N	3	8	112
115	\N	\N	8	126
116	\N	\N	8	159
117	\N	\N	8	168
118	\N	2	8	226
119	\N	\N	8	239
120	\N	\N	8	259
121	\N	1	8	295
122	\N	\N	9	31
123	\N	\N	9	83
124	\N	2	9	94
125	\N	\N	9	138
126	\N	\N	9	139
127	\N	\N	9	175
128	\N	\N	9	197
129	\N	3	9	205
130	\N	\N	9	211
131	\N	\N	9	232
132	\N	\N	9	236
133	\N	1	9	238
134	\N	\N	9	248
135	\N	\N	9	260
136	\N	\N	9	271
137	\N	\N	9	298
138	\N	3	10	8
139	\N	\N	10	26
140	\N	\N	10	32
141	\N	\N	10	70
142	Mención Costumbrista	\N	10	90
143	\N	\N	10	117
144	\N	\N	10	119
145	\N	\N	10	121
146	\N	\N	10	201
148	\N	2	10	208
149	\N	\N	10	210
150	\N	\N	10	228
151	\N	\N	10	238
152	\N	1	10	294
153	\N	\N	11	1
154	\N	\N	11	48
155	\N	\N	11	51
156	\N	\N	11	52
157	\N	\N	11	54
158	\N	1	11	59
159	\N	2	11	62
160	\N	\N	11	65
161	\N	\N	11	84
162	Mención Especial	\N	11	85
163	Mención Costumbrista	\N	11	92
164	\N	3	11	97
165	\N	\N	11	99
166	\N	\N	11	108
167	\N	\N	11	120
168	\N	\N	11	130
169	\N	\N	11	141
170	\N	\N	11	191
171	\N	\N	11	199
172	\N	\N	11	250
173	\N	\N	11	255
174	\N	\N	11	275
175	\N	\N	12	34
176	\N	\N	12	106
177	\N	\N	12	122
178	\N	\N	12	137
179	\N	3	12	142
180	\N	\N	12	145
181	\N	\N	12	154
182	\N	1	12	251
183	Mención Costumbrista	\N	12	266
184	\N	\N	12	270
186	\N	\N	13	8
187	\N	\N	13	26
188	\N	\N	13	44
189	\N	\N	13	50
190	\N	\N	13	53
191	\N	\N	13	79
192	Mención Costumbrista	\N	13	81
193	\N	1	13	90
194	\N	\N	13	100
195	\N	\N	13	113
196	\N	\N	13	128
197	\N	\N	13	157
198	\N	\N	13	201
199	\N	2	13	208
200	Mención Especial	\N	13	228
201	Mención Dibujo	\N	13	238
202	\N	3	13	251
203	\N	\N	13	294
204	\N	\N	14	51
205	\N	\N	14	56
206	\N	1	14	62
207	Mención Dibujo	\N	14	92
208	Mención Costumbrista	\N	14	97
209	\N	\N	14	104
210	\N	3	14	108
211	\N	\N	14	112
212	\N	\N	14	120
213	\N	2	14	152
214	Mención Especial	\N	14	186
215	\N	\N	14	191
216	\N	\N	14	291
217	\N	\N	14	292
218	\N	\N	15	39
219	Mención Especial	\N	15	76
220	Mención Costumbrista	\N	15	95
221	Mención Dibujo	\N	15	106
222	\N	\N	15	122
223	\N	\N	15	131
224	\N	\N	15	138
225	\N	\N	15	142
226	\N	\N	15	212
227	\N	2	15	247
228	\N	1	15	269
230	\N	\N	16	1
231	\N	\N	16	5
232	Mención Especial	\N	16	38
233	\N	\N	16	40
234	\N	3	16	42
235	\N	2	16	43
236	\N	\N	16	65
237	\N	\N	16	68
238	\N	\N	16	130
239	Mención Costumbrista	\N	16	132
240	\N	\N	16	185
241	\N	\N	16	208
242	\N	\N	16	221
243	\N	\N	16	224
244	Mención Especial	\N	16	273
245	\N	1	16	294
246	\N	\N	17	20
247	\N	\N	17	41
248	\N	\N	17	51
249	\N	\N	17	59
250	\N	1	17	62
251	\N	\N	17	72
252	\N	\N	17	82
253	\N	\N	17	86
254	Mención Especial	\N	17	92
255	\N	\N	17	97
256	Mención Costumbrista	\N	17	98
257	\N	\N	17	108
258	\N	3	17	110
259	\N	\N	17	112
260	\N	\N	17	173
261	Mención Especial	\N	17	183
262	\N	\N	17	200
263	\N	\N	17	213
264	\N	\N	17	215
265	\N	\N	17	220
266	\N	\N	17	229
267	\N	\N	17	258
269	\N	\N	17	280
270	\N	\N	17	295
271	\N	2	18	4
272	\N	\N	18	6
273	\N	\N	18	30
274	\N	\N	18	31
275	\N	\N	18	96
276	\N	\N	18	101
277	\N	1	18	102
278	Mención Costumbrista	\N	18	105
279	\N	\N	18	118
280	\N	\N	18	149
281	Mención Especial	\N	18	209
282	\N	\N	18	238
283	\N	2	18	251
284	\N	\N	18	276
285	Mención Dibujo	\N	19	25
286	\N	\N	19	42
287	\N	1	19	43
288	Mención Especial	\N	19	44
289	\N	3	19	102
290	\N	\N	19	156
291	\N	2	19	185
292	\N	3	19	193
293	\N	\N	19	208
294	\N	\N	19	230
295	\N	\N	19	288
296	\N	\N	19	290
297	\N	\N	19	294
298	Mención Dibujo	\N	20	1
299	\N	\N	20	17
300	\N	\N	20	21
301	\N	1	20	36
302	\N	\N	20	51
303	\N	\N	20	56
304	\N	\N	20	59
305	\N	\N	20	62
306	\N	\N	20	69
307	\N	3	20	80
308	\N	\N	20	84
309	Mención Costumbrista	\N	20	86
310	Mención Especial	\N	20	87
311	\N	\N	20	92
312	\N	3	20	97
313	\N	\N	20	103
314	\N	\N	20	160
315	\N	\N	20	161
316	\N	\N	20	163
317	\N	\N	20	165
318	\N	\N	20	180
319	\N	\N	20	189
320	\N	2	20	237
321	\N	\N	20	278
322	Mención Especial	\N	21	71
323	\N	3	21	7
324	\N	\N	21	101
325	\N	\N	21	105
326	\N	\N	21	129
327	\N	\N	21	175
328	\N	\N	21	242
329	Mención Dibujo	\N	21	244
330	\N	1	21	251
332	\N	\N	22	25
333	\N	2	22	79
334	\N	\N	22	90
335	\N	\N	22	102
336	\N	\N	22	119
337	\N	\N	22	128
338	\N	\N	22	185
339	Mención Dibujo	\N	22	188
340	\N	\N	22	190
341	\N	3	22	193
342	Mención Costumbrista	\N	22	208
343	\N	\N	22	216
344	\N	1	22	251
345	Mención Dibujo	\N	22	252
346	\N	\N	22	253
347	\N	\N	22	254
348	\N	\N	22	279
349	\N	\N	22	294
350	Mención Especial	\N	23	16
351	\N	\N	23	43
352	\N	1	23	45
353	\N	\N	23	49
354	\N	\N	23	51
355	\N	3	23	8
356	\N	\N	23	59
357	\N	\N	23	62
358	\N	\N	23	63
359	\N	\N	23	80
360	\N	\N	23	85
361	\N	\N	23	86
362	\N	2	23	92
363	\N	\N	23	97
364	\N	\N	23	136
365	Mención Dibujo	\N	23	161
366	\N	\N	23	171
367	\N	\N	23	179
368	\N	\N	23	189
369	Mención Dibujo	\N	23	237
370	\N	\N	23	262
371	\N	\N	23	302
372	Mención Dibujo	\N	24	24
373	\N	\N	24	34
374	\N	\N	24	88
375	\N	\N	24	106
376	\N	1	24	114
377	\N	\N	24	155
378	\N	\N	24	214
379	\N	\N	24	234
380	\N	2	24	243
381	\N	3	24	244
382	\N	\N	24	267
383	\N	1	24	297
384	Mención Costumbrista	\N	25	22
385	\N	\N	25	25
386	\N	2	25	50
387	\N	\N	25	79
388	\N	\N	25	102
389	\N	\N	25	128
390	\N	\N	25	157
391	Mención Dibujo	\N	25	184
392	\N	\N	25	185
393	\N	3	25	193
394	\N	\N	25	208
395	\N	\N	25	228
396	\N	\N	25	233
397	\N	\N	25	238
398	\N	\N	25	243
399	\N	1	25	251
400	\N	\N	25	252
401	\N	\N	25	254
402	\N	\N	25	257
403	\N	3	25	287
404	\N	2	26	37
405	\N	\N	26	51
406	Mención Dibujo	\N	26	56
407	\N	\N	26	62
408	\N	\N	26	63
409	\N	1	26	77
410	\N	\N	26	80
411	\N	\N	26	92
412	Mención Dibujo	\N	26	97
413	\N	\N	26	115
414	\N	\N	26	124
415	Mención Costumbrista	\N	26	144
416	\N	\N	26	148
417	Mención Costumbrista	\N	26	172
418	\N	3	26	174
419	\N	\N	26	217
420	\N	\N	26	294
421	\N	\N	26	296
422	\N	\N	27	13
423	Mención Dibujo	\N	27	27
424	\N	\N	27	57
425	Mención Especial	\N	27	76
426	\N	\N	27	93
427	Mención Costumbrista	\N	27	106
428	\N	\N	27	122
429	\N	\N	27	127
430	\N	2	27	244
431	\N	3	27	269
432	\N	\N	27	277
434	\N	\N	28	10
435	\N	\N	28	55
436	Mención Costumbrista	\N	28	65
437	\N	1	28	119
438	\N	2	28	132
439	\N	\N	28	151
440	\N	\N	28	162
441	\N	3	28	186
442	\N	3	28	191
443	\N	\N	28	196
444	Mención Costumbrista	\N	28	208
445	\N	\N	28	241
446	\N	\N	28	245
447	\N	\N	28	256
448	\N	\N	28	268
449	\N	\N	28	294
450	\N	3	29	20
451	\N	\N	29	28
452	Mención Costumbrista	\N	29	33
453	\N	\N	29	51
454	\N	\N	29	56
455	\N	1	29	59
456	\N	\N	29	73
457	\N	\N	29	86
458	\N	2	29	92
459	\N	\N	29	97
460	Mención Costumbrista	\N	29	99
461	\N	\N	29	110
462	\N	\N	29	147
463	\N	\N	29	169
464	\N	\N	29	195
465	\N	\N	29	203
466	Mención Costumbrista	\N	29	213
467	\N	\N	29	281
468	\N	\N	29	289
469	2 Online	\N	30	12
470	\N	\N	30	29
471	\N	2	30	31
472	3 Online	\N	30	32
473	\N	\N	30	67
474	\N	\N	30	94
475	\N	\N	30	102
476	\N	\N	30	107
477	\N	\N	30	149
478	\N	\N	30	158
479	\N	\N	30	182
480	\N	\N	30	222
481	\N	3	30	227
482	\N	\N	30	238
483	\N	\N	30	249
484	\N	1	30	251
485	1 Online	\N	30	264
486	\N	\N	31	9
487	\N	2	31	15
488	\N	\N	31	20
489	\N	\N	31	23
490	\N	\N	31	47
491	\N	\N	31	51
492	\N	4	31	60
493	\N	\N	31	86
494	\N	\N	31	91
495	\N	5	31	92
496	Mención Costumbrista	\N	31	99
497	\N	6	31	119
498	\N	\N	31	133
499	\N	\N	31	143
500	\N	\N	31	153
501	\N	\N	31	168
502	\N	\N	31	177
503	\N	\N	31	213
504	\N	1	31	226
505	\N	\N	31	255
506	\N	\N	31	259
507	\N	\N	31	286
508	\N	\N	31	294
509	\N	3	31	295
510	\N	\N	31	301
511	\N	\N	32	20
512	\N	\N	32	38
513	Mejor Reseña	\N	32	51
514	\N	\N	32	56
515	\N	3	32	59
516	\N	\N	32	62
517	\N	\N	32	64
518	\N	\N	32	65
519	\N	\N	32	84
520	\N	\N	32	86
521	\N	\N	32	92
522	Mención Costumbrista	\N	32	97
523	\N	2	32	108
524	\N	1	32	110
525	\N	\N	32	130
526	\N	\N	32	213
527	\N	\N	32	274
528	\N	\N	32	294
529	\N	2	1	1
530	\N	\N	1	11
531	\N	\N	1	65
532	\N	\N	1	116
533	\N	\N	1	119
534	\N	3	1	130
535	\N	1	1	132
536	\N	\N	1	181
537	\N	\N	1	186
538	\N	\N	1	194
539	\N	\N	2	2
540	\N	\N	2	14
541	\N	\N	2	20
542	\N	1	2	33
543	\N	\N	2	35
544	\N	\N	2	46
545	\N	\N	2	51
546	\N	\N	2	59
547	\N	\N	2	62
548	\N	\N	2	73
549	\N	\N	2	74
550	\N	\N	2	78
551	\N	\N	2	80
552	\N	\N	2	92
553	\N	\N	2	97
554	\N	\N	2	99
555	\N	\N	2	108
556	\N	\N	2	135
557	\N	\N	2	150
558	\N	\N	2	177
559	\N	2	2	191
560	\N	\N	2	192
561	\N	3	2	198
562	\N	\N	2	229
563	\N	\N	2	235
564	\N	\N	2	265
565	\N	\N	2	284
566	\N	\N	2	295
567	\N	\N	3	4
568	\N	\N	3	7
569	\N	3	3	18
570	\N	\N	3	94
571	\N	\N	3	96
572	\N	\N	3	118
573	\N	3	3	149
574	\N	\N	3	170
575	\N	\N	3	219
576	\N	\N	3	222
577	\N	2	3	246
578	\N	1	3	251
579	\N	\N	3	272
580	\N	\N	4	1
581	\N	\N	4	58
582	\N	1	4	65
583	\N	\N	4	123
584	\N	\N	4	125
585	\N	\N	4	130
586	\N	\N	4	132
587	\N	3	4	185
588	\N	\N	4	186
589	\N	\N	4	218
590	\N	\N	4	231
591	\N	2	4	274
592	Mención Dibujo	\N	4	279
593	\N	\N	4	282
594	\N	\N	4	285
595	\N	\N	5	3
596	Mención Historia	\N	5	19
597	\N	\N	5	20
598	\N	3	5	45
599	\N	\N	5	46
600	Mención Dibujo	\N	5	51
601	\N	\N	5	62
602	\N	\N	5	73
603	\N	\N	5	86
604	\N	\N	5	92
605	\N	2	5	110
606	\N	\N	5	135
607	\N	\N	5	140
608	\N	\N	5	146
609	\N	\N	5	176
610	\N	\N	5	178
611	\N	1	5	183
612	\N	\N	5	223
613	\N	\N	5	225
614	\N	\N	5	240
615	\N	\N	5	283
616	\N	\N	5	295
617	\N	\N	5	300
618	Mención Dibujo	\N	6	102
619	\N	\N	6	118
620	\N	1	6	129
621	\N	\N	6	164
622	\N	\N	6	207
623	\N	2	6	244
624	Mención Historia	\N	6	251
625	\N	\N	6	293
627	\N	\N	7	38
628	\N	\N	7	61
629	\N	\N	7	75
630	\N	\N	7	119
631	\N	2	7	141
632	\N	\N	7	153
633	\N	3	7	166
634	\N	\N	7	167
635	\N	\N	7	187
636	\N	\N	7	191
637	\N	\N	7	208
638	\N	1	7	255
639	\N	\N	7	261
640	\N	\N	8	51
641	\N	\N	8	92
642	\N	3	8	112
643	\N	\N	8	126
644	\N	\N	8	159
645	\N	\N	8	168
646	\N	2	8	226
647	\N	\N	8	239
648	\N	\N	8	259
649	\N	1	8	295
650	\N	\N	9	31
651	\N	\N	9	83
652	\N	2	9	94
653	\N	\N	9	138
654	\N	\N	9	139
655	\N	\N	9	175
656	\N	\N	9	197
657	\N	3	9	205
658	\N	\N	9	211
659	\N	\N	9	232
660	\N	\N	9	236
661	\N	1	9	238
662	\N	\N	9	248
663	\N	\N	9	260
664	\N	\N	9	271
665	\N	\N	9	298
666	\N	3	10	8
667	\N	\N	10	26
668	\N	\N	10	32
669	\N	\N	10	70
670	Mención Costumbrista	\N	10	90
671	\N	\N	10	117
672	\N	\N	10	119
673	\N	\N	10	121
674	\N	\N	10	201
676	\N	2	10	208
677	\N	\N	10	210
678	\N	\N	10	228
679	\N	\N	10	238
680	\N	1	10	294
681	\N	\N	11	1
682	\N	\N	11	48
683	\N	\N	11	51
684	\N	\N	11	52
685	\N	\N	11	54
686	\N	1	11	59
687	\N	2	11	62
688	\N	\N	11	65
689	\N	\N	11	84
690	Mención Especial	\N	11	85
691	Mención Costumbrista	\N	11	92
692	\N	3	11	97
693	\N	\N	11	99
694	\N	\N	11	108
695	\N	\N	11	120
696	\N	\N	11	130
697	\N	\N	11	141
698	\N	\N	11	191
699	\N	\N	11	199
700	\N	\N	11	250
701	\N	\N	11	255
702	\N	\N	11	275
703	\N	\N	12	34
704	\N	\N	12	106
705	\N	\N	12	122
706	\N	\N	12	137
707	\N	3	12	142
708	\N	\N	12	145
709	\N	\N	12	154
710	\N	1	12	251
711	Mención Costumbrista	\N	12	266
712	\N	\N	12	270
714	\N	\N	13	8
715	\N	\N	13	26
716	\N	\N	13	44
717	\N	\N	13	50
718	\N	\N	13	53
719	\N	\N	13	79
720	Mención Costumbrista	\N	13	81
721	\N	1	13	90
722	\N	\N	13	100
723	\N	\N	13	113
724	\N	\N	13	128
725	\N	\N	13	157
726	\N	\N	13	201
727	\N	2	13	208
728	Mención Especial	\N	13	228
729	Mención Dibujo	\N	13	238
730	\N	3	13	251
731	\N	\N	13	294
732	\N	\N	14	51
733	\N	\N	14	56
734	\N	1	14	62
735	Mención Dibujo	\N	14	92
736	Mención Costumbrista	\N	14	97
737	\N	\N	14	104
738	\N	3	14	108
739	\N	\N	14	112
740	\N	\N	14	120
741	\N	2	14	152
742	Mención Especial	\N	14	186
743	\N	\N	14	191
744	\N	\N	14	291
745	\N	\N	14	292
746	\N	\N	15	39
747	Mención Especial	\N	15	76
748	Mención Costumbrista	\N	15	95
749	Mención Dibujo	\N	15	106
750	\N	\N	15	122
751	\N	\N	15	131
752	\N	\N	15	138
753	\N	\N	15	142
754	\N	\N	15	212
755	\N	2	15	247
756	\N	1	15	269
758	\N	\N	16	1
759	\N	\N	16	5
760	Mención Especial	\N	16	38
761	\N	\N	16	40
762	\N	3	16	42
763	\N	2	16	43
764	\N	\N	16	65
765	\N	\N	16	68
766	\N	\N	16	130
767	Mención Costumbrista	\N	16	132
768	\N	\N	16	185
769	\N	\N	16	208
770	\N	\N	16	221
771	\N	\N	16	224
772	Mención Especial	\N	16	273
773	\N	1	16	294
774	\N	\N	17	20
775	\N	\N	17	41
776	\N	\N	17	51
777	\N	\N	17	59
778	\N	1	17	62
779	\N	\N	17	72
780	\N	\N	17	82
781	\N	\N	17	86
782	Mención Especial	\N	17	92
783	\N	\N	17	97
784	Mención Costumbrista	\N	17	98
785	\N	\N	17	108
786	\N	3	17	110
787	\N	\N	17	112
788	\N	\N	17	173
789	Mención Especial	\N	17	183
790	\N	\N	17	200
791	\N	\N	17	213
792	\N	\N	17	215
793	\N	\N	17	220
794	\N	\N	17	229
795	\N	\N	17	258
797	\N	\N	17	280
798	\N	\N	17	295
799	\N	2	18	4
800	\N	\N	18	6
801	\N	\N	18	30
802	\N	\N	18	31
803	\N	\N	18	96
804	\N	\N	18	101
805	\N	1	18	102
806	Mención Costumbrista	\N	18	105
807	\N	\N	18	118
808	\N	\N	18	149
809	Mención Especial	\N	18	209
810	\N	\N	18	238
811	\N	2	18	251
812	\N	\N	18	276
813	Mención Dibujo	\N	19	25
814	\N	\N	19	42
815	\N	1	19	43
816	Mención Especial	\N	19	44
817	\N	3	19	102
818	\N	\N	19	156
819	\N	2	19	185
820	\N	3	19	193
821	\N	\N	19	208
822	\N	\N	19	230
823	\N	\N	19	288
824	\N	\N	19	290
825	\N	\N	19	294
826	Mención Dibujo	\N	20	1
827	\N	\N	20	17
828	\N	\N	20	21
829	\N	1	20	36
830	\N	\N	20	51
831	\N	\N	20	56
832	\N	\N	20	59
833	\N	\N	20	62
834	\N	\N	20	69
835	\N	3	20	80
836	\N	\N	20	84
837	Mención Costumbrista	\N	20	86
838	Mención Especial	\N	20	87
839	\N	\N	20	92
840	\N	3	20	97
841	\N	\N	20	103
842	\N	\N	20	160
843	\N	\N	20	161
844	\N	\N	20	163
845	\N	\N	20	165
846	\N	\N	20	180
847	\N	\N	20	189
848	\N	2	20	237
849	\N	\N	20	278
850	Mención Especial	\N	21	71
851	\N	3	21	7
852	\N	\N	21	101
853	\N	\N	21	105
854	\N	\N	21	129
855	\N	\N	21	175
856	\N	\N	21	242
857	Mención Dibujo	\N	21	244
858	\N	1	21	251
860	\N	\N	22	25
861	\N	2	22	79
862	\N	\N	22	90
863	\N	\N	22	102
864	\N	\N	22	119
865	\N	\N	22	128
866	\N	\N	22	185
867	Mención Dibujo	\N	22	188
868	\N	\N	22	190
869	\N	3	22	193
870	Mención Costumbrista	\N	22	208
871	\N	\N	22	216
872	\N	1	22	251
873	Mención Dibujo	\N	22	252
874	\N	\N	22	253
875	\N	\N	22	254
876	\N	\N	22	279
877	\N	\N	22	294
878	Mención Especial	\N	23	16
879	\N	\N	23	43
880	\N	1	23	45
881	\N	\N	23	49
882	\N	\N	23	51
883	\N	3	23	8
884	\N	\N	23	59
885	\N	\N	23	62
886	\N	\N	23	63
887	\N	\N	23	80
888	\N	\N	23	85
889	\N	\N	23	86
890	\N	2	23	92
891	\N	\N	23	97
892	\N	\N	23	136
893	Mención Dibujo	\N	23	161
894	\N	\N	23	171
895	\N	\N	23	179
896	\N	\N	23	189
897	Mención Dibujo	\N	23	237
898	\N	\N	23	262
899	\N	\N	23	302
900	Mención Dibujo	\N	24	24
901	\N	\N	24	34
902	\N	\N	24	88
903	\N	\N	24	106
904	\N	1	24	114
905	\N	\N	24	155
906	\N	\N	24	214
907	\N	\N	24	234
908	\N	2	24	243
909	\N	3	24	244
910	\N	\N	24	267
911	\N	1	24	297
912	Mención Costumbrista	\N	25	22
913	\N	\N	25	25
914	\N	2	25	50
915	\N	\N	25	79
916	\N	\N	25	102
917	\N	\N	25	128
918	\N	\N	25	157
919	Mención Dibujo	\N	25	184
920	\N	\N	25	185
921	\N	3	25	193
922	\N	\N	25	208
923	\N	\N	25	228
924	\N	\N	25	233
925	\N	\N	25	238
926	\N	\N	25	243
927	\N	1	25	251
928	\N	\N	25	252
929	\N	\N	25	254
930	\N	\N	25	257
931	\N	3	25	287
932	\N	2	26	37
933	\N	\N	26	51
934	Mención Dibujo	\N	26	56
935	\N	\N	26	62
936	\N	\N	26	63
937	\N	1	26	77
938	\N	\N	26	80
939	\N	\N	26	92
940	Mención Dibujo	\N	26	97
941	\N	\N	26	115
942	\N	\N	26	124
943	Mención Costumbrista	\N	26	144
944	\N	\N	26	148
945	Mención Costumbrista	\N	26	172
946	\N	3	26	174
947	\N	\N	26	217
948	\N	\N	26	294
949	\N	\N	26	296
950	\N	\N	27	13
951	Mención Dibujo	\N	27	27
952	\N	\N	27	57
953	Mención Especial	\N	27	76
954	\N	\N	27	93
955	Mención Costumbrista	\N	27	106
956	\N	\N	27	122
957	\N	\N	27	127
958	\N	2	27	244
959	\N	3	27	269
960	\N	\N	27	277
962	\N	\N	28	10
963	\N	\N	28	55
964	Mención Costumbrista	\N	28	65
965	\N	1	28	119
966	\N	2	28	132
967	\N	\N	28	151
968	\N	\N	28	162
969	\N	3	28	186
970	\N	3	28	191
971	\N	\N	28	196
972	Mención Costumbrista	\N	28	208
973	\N	\N	28	241
974	\N	\N	28	245
975	\N	\N	28	256
976	\N	\N	28	268
977	\N	\N	28	294
978	\N	3	29	20
979	\N	\N	29	28
980	Mención Costumbrista	\N	29	33
981	\N	\N	29	51
982	\N	\N	29	56
983	\N	1	29	59
984	\N	\N	29	73
985	\N	\N	29	86
986	\N	2	29	92
987	\N	\N	29	97
988	Mención Costumbrista	\N	29	99
989	\N	\N	29	110
990	\N	\N	29	147
991	\N	\N	29	169
992	\N	\N	29	195
993	\N	\N	29	203
994	Mención Costumbrista	\N	29	213
995	\N	\N	29	281
996	\N	\N	29	289
997	2 Online	\N	30	12
998	\N	\N	30	29
999	\N	2	30	31
1000	3 Online	\N	30	32
1001	\N	\N	30	67
1002	\N	\N	30	94
1003	\N	\N	30	102
1004	\N	\N	30	107
1005	\N	\N	30	149
1006	\N	\N	30	158
1007	\N	\N	30	182
1008	\N	\N	30	222
1009	\N	3	30	227
1010	\N	\N	30	238
1011	\N	\N	30	249
1012	\N	1	30	251
1013	1 Online	\N	30	264
1014	\N	\N	31	9
1015	\N	2	31	15
1016	\N	\N	31	20
1017	\N	\N	31	23
1018	\N	\N	31	47
1019	\N	\N	31	51
1020	\N	4	31	60
1021	\N	\N	31	86
1022	\N	\N	31	91
1023	\N	5	31	92
1024	Mención Costumbrista	\N	31	99
1025	\N	6	31	119
1026	\N	\N	31	133
1027	\N	\N	31	143
1028	\N	\N	31	153
1029	\N	\N	31	168
1030	\N	\N	31	177
1031	\N	\N	31	213
1032	\N	1	31	226
1033	\N	\N	31	255
1034	\N	\N	31	259
1035	\N	\N	31	286
1036	\N	\N	31	294
1037	\N	3	31	295
1038	\N	\N	31	301
1039	\N	\N	32	20
1040	\N	\N	32	38
1041	Mejor Reseña	\N	32	51
1042	\N	\N	32	56
1043	\N	3	32	59
1044	\N	\N	32	62
1045	\N	\N	32	64
1046	\N	\N	32	65
1047	\N	\N	32	84
1048	\N	\N	32	86
1049	\N	\N	32	92
1050	Mención Costumbrista	\N	32	97
1051	\N	2	32	108
1052	\N	1	32	110
1053	\N	\N	32	130
1054	\N	\N	32	213
1055	\N	\N	32	274
1056	\N	\N	32	294
268	\N	2	17	35
796	\N	2	17	35
147	\N	\N	10	132
675	\N	\N	10	132
98	\N	3	6	297
185	\N	2	12	297
229	\N	3	15	297
331	\N	2	21	297
433	\N	1	27	297
626	\N	3	6	297
713	\N	2	12	297
757	\N	3	15	297
859	\N	2	21	297
961	\N	1	27	297
1057	\N	2	34	455
1058	\N	1	34	39
1059	mención dibujo	\N	34	95
1060	\N	3	34	368
1061	mención costumbrista	\N	34	76
1062	\N	\N	34	456
1063	\N	3	34	269
1064	\N	\N	34	457
1065	\N	\N	34	458
1066	\N	\N	34	459
1067	\N	\N	34	460
1068	\N	\N	35	228
1069	\N	3	35	247
1070	\N	2	35	157
1071	Mención Dibujo	\N	35	251
1072	Mención costumbrista	\N	35	238
1073	\N	3	35	81
1074	\N	\N	35	4
1075	\N	1	35	50
1076	\N	\N	35	367
1077	\N	\N	35	53
1078	\N	\N	35	461
1079	\N	\N	35	462
1080	\N	\N	35	297
1081	\N	\N	35	44
1082	\N	\N	35	90
1083	\N	\N	35	463
1084	\N	\N	35	13
1085	\N	\N	35	464
1086	\N	\N	35	122
1087	\N	\N	35	465
1088	\N	\N	35	466
1089	\N	\N	35	467
1090	\N	\N	35	468
1091	Dibujo	\N	36	128
1092	\N	\N	36	208
1093	\N	2	36	97
1094	\N	\N	36	51
1095	\N	3	36	92
1096	\N	\N	36	108
1097	\N	\N	36	469
1098	\N	\N	36	201
1099	costumbrismo	\N	36	255
1100	\N	\N	36	86
1101	\N	\N	36	294
1102	\N	\N	36	56
1103	\N	\N	36	121
1104	especial Fundastohr	\N	36	191
1105	\N	\N	36	79
1106	\N	\N	36	104
1107	\N	\N	36	119
1108	\N	\N	36	366
1109	\N	1	36	186
1110	\N	\N	36	470
1111	\N	\N	36	291
1112	\N	\N	36	152
1113	\N	\N	36	471
1114	\N	\N	36	472
1115	\N	\N	36	473
\.


--
-- Data for Name: concurso; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.concurso (id_concurso, nombre, fecha, categoria, tema) FROM stdin;
1	Concurso de Dibujo ACNUR 2020	2020-06-15	Juvenil	\N
2	Concurso de Dibujo ACNUR 2020	2020-06-15	Adulto	\N
3	Concurso de Dibujo ACNUR 2020	2020-06-15	Infantil	\N
4	Concurso de Dibujo ACNUR 2021	2021-06-26	Juvenil	\N
5	Concurso de Dibujo ACNUR 2021	2021-06-26	Adulto	\N
6	Concurso de Dibujo ACNUR 2021	2021-06-26	Infantil	\N
7	Concurso de Dibujo Fundastohr 2019	2019-04-06	Juvenil	\N
8	Concurso de Dibujo Fundastohr 2019	2019-04-06	Adulto	\N
9	Concurso de Dibujo Fundastohr 2019	2019-04-06	Infantil	\N
10	Concurso de Dibujo Fundastohr 2022	2022-08-20	Juvenil	\N
11	Concurso de Dibujo Fundastohr 2022	2022-08-20	Adulto	\N
12	Concurso de Dibujo Fundastohr 2022	2022-08-20	Infantil	\N
13	Concurso de Dibujo Fundastohr 2023	2023-11-04	Juvenil	\N
14	Concurso de Dibujo Fundastohr 2023	2023-11-04	Adulto	\N
15	Concurso de Dibujo Fundastohr 2023	2023-11-04	Infantil	\N
16	Concurso de Dibujo Urbano 2021	2021-02-26	Juvenil	\N
17	Concurso de Dibujo Urbano 2021	2021-02-26	Adulto	\N
18	Concurso de Dibujo Urbano 2021	2021-02-26	Infantil	\N
19	Concurso de Dibujo Urbano 2022	2022-02-22	Juvenil	\N
20	Concurso de Dibujo Urbano 2022	2022-02-22	Adulto	\N
21	Concurso de Dibujo Urbano 2022	2022-02-22	Infantil	\N
22	Concurso de Dibujo Urbano 2023	2023-02-17	Juvenil	\N
23	Concurso de Dibujo Urbano 2023	2023-02-17	Adulto	\N
24	Concurso de Dibujo Urbano 2023	2023-02-17	Infantil	\N
25	Concurso de Dibujo Urbano 2024	2024-02-09	Juvenil	\N
26	Concurso de Dibujo Urbano 2024	2024-02-09	Adulto	\N
27	Concurso de Dibujo Urbano 2024	2024-02-09	Infantil	\N
28	Concurso Margarita Proteccion y Devocion 2020	2020-04-12	Juvenil	\N
29	Concurso Margarita Proteccion y Devocion 2020	2020-04-12	Adulto	\N
30	Concurso Margarita Proteccion y Devocion 2020	2020-04-12	Infantil	\N
31	Concurso de Dibujo Temático 2019	2019-08-24	\N	Iglesia Nueva Esparta
32	Concurso de Dibujo Temático 2021	2021-10-30	\N	Cocina Margariteña
35	Concurso de Dibujo Fundastohr Tacarigua 2025	2025-04-13	Juvenil	N/A
34	Concurso de Dibujo Fundastohr Tacarigua 2025	2025-04-13	Infantil	N/A
36	Concurso de Dibujo Fundastohr Tacarigua 2025	2025-04-13	Adulto	N/A
\.


--
-- Data for Name: e_p; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.e_p (id, exposicion_id, participante_id, obra_id, numero_obra) FROM stdin;
21	1	1	\N	1
22	1	11	\N	1
23	1	18	\N	1
24	1	19	\N	1
25	1	33	\N	1
26	1	45	\N	1
27	1	46	\N	1
28	1	51	\N	1
29	1	62	\N	1
30	1	65	\N	1
31	1	86	\N	1
32	1	92	\N	1
33	1	97	\N	1
34	1	102	\N	1
35	1	110	\N	1
36	1	129	\N	1
37	1	130	\N	2
38	1	132	\N	1
39	1	135	\N	1
40	1	149	\N	1
41	1	183	\N	1
42	1	185	\N	1
43	1	191	\N	1
44	1	194	\N	1
45	1	198	\N	1
46	1	244	\N	1
47	1	246	\N	1
48	1	251	\N	2
49	1	274	\N	1
50	1	279	\N	1
51	1	284	\N	1
52	1	295	\N	1
53	1	297	\N	1
330	36	168	\N	1
331	36	226	\N	2
332	36	208	\N	3
333	36	255	\N	4
334	36	15	\N	5
335	36	119	\N	6
336	36	47	\N	7
337	36	51	\N	8
338	36	20	\N	9
339	36	213	\N	10
340	36	91	\N	11
341	36	286	\N	12
342	36	92	\N	13
343	36	143	\N	14
344	36	153	\N	15
345	36	294	\N	16
346	36	86	\N	17
347	36	295	\N	18
348	36	60	\N	19
349	36	9	\N	20
350	36	133	\N	21
351	36	301	\N	22
352	36	259	\N	23
353	36	99	\N	24
354	36	177	\N	25
355	38	62	876	1
356	38	51	877	2
357	38	92	878	3
358	38	59	879	4
359	38	274	880	5
360	38	213	881	6
361	38	20	882	7
362	38	84	883	8
363	38	130	884	9
364	38	65	885	10
365	38	38	886	11
366	38	110	887	12
367	38	64	888	13
368	38	108	889	14
369	38	86	890	15
370	38	294	891	16
371	38	97	892	17
372	38	56	893	18
373	34	97	894	1
374	34	108	895	2
375	34	186	896	3
376	34	62	897	4
377	34	110	898	5
378	34	15	899	6
379	34	119	900	7
380	34	60	901	8
381	34	141	902	9
382	34	20	903	10
383	34	92	904	11
384	34	213	905	12
385	34	65	906	13
386	34	295	907	14
387	34	51	908	15
388	34	198	909	16
389	34	331	910	17
390	34	331	911	18
391	34	331	912	19
392	34	331	913	20
393	35	8	914	1
394	35	51	915	2
395	35	62	916	3
396	35	65	917	4
397	35	85	918	5
398	35	90	919	6
399	35	92	920	7
400	35	97	921	8
401	35	121	922	9
402	35	142	923	10
403	35	191	924	11
404	35	208	925	12
405	35	54	926	13
406	35	251	927	14
407	35	266	928	15
408	35	275	929	16
409	35	294	930	17
410	35	297	931	18
411	35	333	932	19
412	35	334	933	20
413	37	269	934	1
414	37	297	935	2
415	37	247	936	3
416	37	51	937	4
417	37	97	938	5
418	37	108	939	6
419	37	106	940	7
420	37	95	941	8
421	37	294	942	9
422	37	228	943	10
423	37	100	944	11
424	37	186	945	12
425	37	92	946	13
426	37	208	947	14
427	37	238	948	15
428	37	79	949	16
429	37	90	950	17
430	37	251	951	18
431	37	81	952	19
432	37	152	953	20
433	37	76	954	21
434	42	366	955	1
435	42	39	956	2
436	42	56	957	3
437	42	76	958	4
438	42	81	959	5
439	42	92	960	6
440	42	95	961	7
441	42	97	962	8
442	42	106	963	9
443	42	122	964	10
444	42	128	965	11
445	42	367	966	12
446	42	157	967	13
447	42	186	968	14
448	42	191	969	15
449	42	208	970	16
450	42	228	971	17
451	42	238	972	18
452	42	78	973	19
453	42	255	974	20
454	42	368	975	21
455	42	269	976	22
456	42	291	977	23
457	42	294	978	24
458	42	297	979	25
459	42	247	\N	2
460	42	50	\N	7
461	40	22	980	1
462	40	27	981	2
463	40	37	982	3
464	40	45	983	4
465	40	331	984	5
466	40	331	985	6
467	40	355	986	7
468	40	49	987	8
469	40	50	988	9
470	40	56	989	10
471	40	362	990	11
472	40	59	991	12
473	40	66	992	13
474	40	77	993	14
475	40	363	994	15
476	40	80	995	16
477	40	92	996	17
478	40	356	997	18
479	40	97	998	19
480	40	111	999	20
481	40	161	1000	21
482	40	172	1001	22
483	40	184	1002	23
484	40	358	1003	24
485	40	193	1004	25
486	40	359	1005	26
487	40	237	1006	27
488	40	247	1007	28
489	40	251	1008	29
490	40	257	1009	30
491	40	35	1010	31
492	40	287	1011	32
493	40	360	1012	33
494	40	295	1013	34
495	39	22	1014	1
496	39	27	1015	2
497	39	37	1016	3
498	39	45	1017	4
499	39	331	1018	5
500	39	355	1019	6
501	39	49	1020	7
502	39	50	1021	8
503	39	56	1022	9
504	39	66	1023	10
505	39	77	1024	11
506	39	80	1025	12
507	39	92	1026	13
508	39	356	1027	14
509	39	97	1028	15
510	39	111	1029	16
511	39	157	1030	17
512	39	161	1031	18
513	39	357	1032	19
514	39	357	1033	20
515	39	357	1034	21
516	39	172	1035	22
517	39	184	1036	23
518	39	358	1037	24
519	39	193	1038	25
520	39	359	1039	26
521	39	228	1040	27
522	39	237	1041	28
523	39	247	1042	29
524	39	251	1043	30
525	39	257	1044	31
526	39	35	1045	32
527	39	287	1046	33
528	39	360	1047	34
529	43	295	1048	1
530	43	295	1049	2
531	43	295	1050	3
532	43	295	1051	4
533	43	295	1052	5
534	43	295	1053	6
535	43	295	1054	7
536	43	295	1055	8
537	43	295	1056	9
538	43	295	1057	10
539	43	295	1058	11
540	43	295	1059	12
541	43	295	1060	13
542	43	295	1061	14
543	43	295	1062	15
544	43	295	1063	16
545	43	295	1064	17
546	43	295	1065	18
547	43	295	1066	19
548	43	295	1067	20
549	43	295	1068	21
550	43	295	1069	22
551	43	295	1070	23
552	43	295	1071	24
553	43	295	1072	25
554	45	59	1073	1
555	45	59	1074	2
556	45	59	1075	3
557	45	59	1076	4
558	45	59	1077	5
559	45	59	1078	6
560	45	59	1079	7
561	45	59	1080	8
562	45	59	1081	9
563	45	59	1082	10
564	45	59	1083	11
565	45	59	1084	12
566	45	59	1085	13
567	45	59	1086	14
568	45	59	1087	15
569	45	59	1088	16
570	45	59	1089	17
571	45	59	1090	18
572	45	59	1091	19
573	45	59	1092	20
574	45	59	1093	21
575	46	59	1094	1
576	46	59	1095	2
577	46	59	1096	3
578	46	59	1097	4
579	46	59	1098	5
580	46	59	1099	6
581	46	59	1100	7
582	46	59	1101	8
583	46	59	1102	9
584	46	59	1103	10
585	46	59	1104	11
586	46	59	1105	12
587	47	62	1106	1
588	47	62	1107	2
589	47	62	1108	3
590	47	62	1109	4
591	47	62	1110	5
592	47	62	1111	6
593	47	62	1112	7
594	47	62	1113	8
595	47	62	1114	9
596	47	62	1115	10
597	47	62	1116	11
598	47	62	1117	12
599	47	62	1118	13
600	47	62	1119	14
601	47	62	1120	15
602	47	62	1121	16
603	47	62	1122	17
604	47	62	1123	18
605	47	62	1124	19
606	47	62	1125	20
607	47	62	1126	21
608	47	62	1127	22
609	47	62	1128	23
610	47	62	1129	24
611	47	62	1130	25
612	47	62	1131	26
613	47	62	1132	27
614	47	62	1133	28
615	47	62	1134	29
616	47	62	1135	30
617	47	62	1136	31
618	47	62	1137	32
619	47	62	1138	33
620	47	62	1139	34
621	47	62	1140	35
622	48	295	1141	1
623	48	295	1142	2
624	48	295	1143	3
625	48	295	1144	4
626	48	295	1145	5
627	48	295	1146	6
628	48	295	1147	7
629	48	295	1148	8
630	48	295	1149	9
631	48	295	1150	10
632	48	295	1151	11
633	48	295	1152	12
634	48	295	1153	13
635	48	295	1154	14
636	49	251	1155	1
637	49	251	1156	2
638	49	251	1157	3
639	49	251	1158	4
640	49	251	1159	5
641	49	251	1160	6
642	49	251	1161	7
643	49	251	1162	8
644	49	251	1163	9
645	49	251	1164	10
\.


--
-- Data for Name: en_p; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.en_p (id, encuentro_id, participante_id) FROM stdin;
1	1	369
2	1	217
3	1	172
4	1	370
5	1	371
6	1	372
7	1	373
8	1	374
9	1	375
10	1	376
11	1	377
12	1	378
13	1	379
14	1	380
15	1	381
16	1	382
18	1	66
19	1	384
20	1	385
21	1	386
22	1	387
23	1	161
24	1	388
25	1	389
26	1	390
27	1	391
28	1	392
29	1	393
30	1	394
31	1	395
32	1	396
33	1	397
34	1	356
35	1	111
36	1	398
37	1	399
38	1	400
39	1	358
40	1	401
41	1	402
17	1	359
\.


--
-- Data for Name: encuentro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.encuentro (id_encuentro, nombre, fecha, lugar) FROM stdin;
1	Documentando la Patora USKCCS	2025-10-10	La pastora, Caracas
\.


--
-- Data for Name: estado; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.estado (id_estado, nombre) FROM stdin;
1	Amazonas
2	Anzoátegui
3	Apure
4	Aragua
5	Barinas
6	Bolívar
7	Carabobo
8	Cojedes
9	Delta Amacuro
10	Distrito Capital
11	Falcón
12	Guárico
13	La Guaira
14	Lara
15	Mérida
16	Miranda
17	Monagas
18	Nueva Esparta
19	Portuguesa
20	Sucre
21	Táchira
22	Trujillo
23	Yaracuy
24	Zulia
\.


--
-- Data for Name: exposicion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.exposicion (id_expo, nombre, fecha, tipo, lugar, tema) FROM stdin;
1	Dibujando Historias de Oportunidad en la Adversidad	2022-01-01	Colectiva	Galería de Arte Nacional y UNMET	\N
36	Iglesias de Nueva Esparta 2019	2019-10-15	Colectiva	Centro de arte Omar Carreño, Estado Nueva Esparta	Iglesias de Nueva Esparta
38	Cocina Margariteña 2021	2021-10-30	Colectiva	Museo Nueva Cadiz, sala Carlos Stohr	Cocina Margariteña
34	Margarita, Terruño Insular 2022	2022-04-01	Colectiva	Itinerante por la Isla de Margarita	Terruño Insular
35	Dibujando a la Ciudad de Pampatar 2023	2023-03-01	Colectiva	Museo Nueva Cadiz, Estado Nueva Esparta	Ciudad de Pampatar
37	Dibujando a El Valle del Espíritu Santo 2024	2024-03-01	Colectiva	Museo Nueva Cádiz. Estado Nueva Esparta	El Valle del Espíritu Santo
42	Dibujando al Pueblo de Tacarigua	2025-01-01	Colectiva	Casa de la Cultura Manuel Plácido Maneiro	Pueblo de Tacarigua
40	Dibujo Urbano Vzla CAOC 2025	2025-08-09	Colectiva	Centro de Arte Omar Carreño	Selección USKVzla
39	Dibujo Urbano Vzla MAM 2025	2025-08-09	Colectiva	Museo Arturo Michelena	Selección USKVzla
43	Yurenny Oliveros - Mirada Insular	2019-11-02	Individual	Museo de Arte Contemporáneo Francisco Narváez, Estado Nueva Esparta	\N
45	Daniela Millán – Extrospección	2023-03-01	Individual	Centro de Arte Omar Carreño – Estado Nueva Esparta	\N
46	Daniela Millán - Paisajismo (GAN)	2023-07-15	Individual	Galería de Arte Nacional - Programa Artista Joven	\N
47	Paraíso - Darlenys Castillo	2024-03-02	Individual	Centro de Arte Omar Carreño, Estado Nueva Esparta	\N
48	Analogía de un Hogar - Yurenny Oliveros	2025-02-08	Individual	Galería de Arte Nacional - Programa Artista Joven	\N
49	Momentos de Insularidad - Sandra Jiménez	2025-08-09	Individual	Galería de Arte Nacional – Programa Espacio Infantil	\N
\.


--
-- Data for Name: obra; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.obra (id_obra, numero_obra, titulo, tecnica, ancho, alto, anio, tema, estilo, ubicacion, observacion, participante_id, created_at, updated_at) FROM stdin;
1074	2	Torre Salvavidas	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	22.9 × 30.5 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1075	3	Museo Pueblos de Margarita Taguantar	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	IGLESIA VIRGEN DEL VALLE	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1076	4	Iglesia Virgen del Valle	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	CAPILLA DE LA SANTA CRUZ	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1077	5	Capilla de la Santa Cruz	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	CALLEJÓN EL NORTE	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1078	6	Callejón El Norte	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	CERRO COPEY	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1079	7	Cerro Copey	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	PLAYA EL YAQUE	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1080	8	Playa El Yaque	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	PEDREGALES	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1081	9	Pedregales	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	CERRO ALEGRE	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1082	10	Cerro Alegre	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	RIO SUPERMARKET SAMBIL	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1083	11	Río Supermarket Sambil	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	RUINA DE TELECARIBE	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1084	12	Ruina de Telecaribe	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	PARQUE NACIONAL ÁVILA Caracas 2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1085	13	Parque Nacional Ávila	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	Caracas 2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1086	14	Paseo Los Próceres	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1087	15	Señoras	Mixta sobre papel	29.70	42.00	2022	\N	\N	\N	2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1088	16	Peces Koi Sambil	Acuarela y tinta sobre papel	29.70	42.00	2022	\N	\N	\N	2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1089	17	Pescador	Acuarela y tinta sobre papel	29.70	42.00	2022	\N	\N	\N	2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1090	18	Rutina I	Gouache sobre opalina	48.00	48.00	2022	\N	\N	\N	2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1091	19	Rutina II	Gouache sobre opalina	48.00	48.00	2022	\N	\N	\N	2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1092	20	Autobús	Gouache sobre opalina	48.00	48.00	2022	\N	\N	\N	2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1093	21	Diagnósticos Psiquiátrico (10 obras - diferentes personalidades)	Mixta sobre papel	29.00	29.00	2022	\N	\N	\N		59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
876	1	Ajíes Margariteños Rellenos	\N	\N	\N	2021	\N	\N	\N	\N	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
877	2	Anafe	\N	\N	\N	2021	\N	\N	\N	\N	51	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
878	3	Bombón Margariteño	\N	\N	\N	2021	\N	\N	\N	\N	92	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
879	4	Comida Margariteña	\N	\N	\N	2021	\N	\N	\N	\N	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
880	5	Corocoro Frito	\N	\N	\N	2021	\N	\N	\N	\N	274	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
881	6	Dulce de Lechoza	\N	\N	\N	2021	\N	\N	\N	\N	213	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
882	7	El Tomate Margariteño	\N	\N	\N	2021	\N	\N	\N	\N	20	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
883	8	Fosforera ¡un Manjar de la Isla!	\N	\N	\N	2021	\N	\N	\N	\N	84	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
884	9	Fosforera Margariteña	\N	\N	\N	2021	\N	\N	\N	\N	130	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
885	10	La Doña del Comodoro	\N	\N	\N	2021	\N	\N	\N	\N	65	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
886	11	La Pesa de Mis Bisabuelos Daniela Caraballo y Olegario Malaver	\N	\N	\N	2021	\N	\N	\N	\N	38	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
887	12	Lula y Su Sancocho	\N	\N	\N	2021	\N	\N	\N	\N	110	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
888	13	Me Das Una Empanadas Porfavor	\N	\N	\N	2021	\N	\N	\N	\N	64	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
889	14	Nada Más Bueno Que Una Empanada Margariteña	\N	\N	\N	2021	\N	\N	\N	\N	108	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
890	15	Sabor A la Orilla de Margarita	\N	\N	\N	2021	\N	\N	\N	\N	86	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
891	16	Sabor Marino	\N	\N	\N	2021	\N	\N	\N	\N	294	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
892	17	Sazón Margariteña	\N	\N	\N	2021	\N	\N	\N	\N	97	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
893	18	Un Día en el Patio de Mis Abuelos	\N	\N	\N	2021	\N	\N	\N	\N	56	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
894	1	Me Das Una Empanadas Porfavor	Creyones y Tiza sobre papel	\N	\N	2021	\N	\N	\N	23 x 33cm	97	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
895	2	Lula y Su Sancocho	Creyones sobre papel	\N	\N	2021	\N	\N	\N	22cm x 28cm	108	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
896	3	María	Creyones sobre papel	\N	\N	2020	\N	\N	\N	30 x 40 cm	186	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
897	4	Casa Azul de Pampatar	Acuarela y tinta	\N	\N	2021	\N	\N	\N	22.9 x 30.5 cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
898	5	Sustento Diario	Acuarela Sobre Papel	\N	\N	2021	\N	\N	\N	29x38 cm	110	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
899	6	Mi Catedral	mixta, acuarela y plumilla sobre papel	\N	\N	2019	\N	\N	\N	34 x 28 cm	15	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
900	7	El Punto de Encuentro del Cristo del Buen Viaje	Carboncillo sobre papel	\N	\N	2019	\N	\N	\N	28.5 x 34.5	119	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
901	8	Iglesia de San Juan Evangelista, Juangriego.	Tintura natural, plumilla y pincel sobre papel.	\N	\N	2019	\N	\N	\N	28 x 34 cm	60	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
902	9	Vistazo A la Plaza	Tinta sobre papel	\N	\N	2019	\N	\N	\N	34,5 x 28 cm	141	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
903	10	Tradición Asuntina, el Encuentro de la Madre con Su Hijo	Carboncillo sobre papel	\N	\N	2020	\N	\N	\N	21,6  X 27,8 cm	20	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
904	11	Pintando las Fachadas Coloniales de Mi Pueblo y Su Gente	Tinta china sobre papel	\N	\N	2021	\N	\N	\N	23x31cm	92	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
905	12	Septiembre en el Manglillo	Carboncillo sobre papel	\N	\N	2020	\N	\N	\N	21,6  X 27,8 cm	213	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
906	13	Nuestras Raíces	Grafito sobre papel	\N	\N	2020	\N	\N	\N	21,6 x 27,8 cm	65	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
907	14	Morada de Un Pescador (el Guamache)	Tinta sobre papel	\N	\N	2019	\N	\N	\N	23 x 31 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
908	15	Vista Desde Paraguachí	Acuarela y tinta sobre papel	\N	\N	2022	\N	\N	\N	30 x 23cm	51	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
909	16	Chelias Villarroel	Mixta sobre papel	\N	\N	2020	\N	\N	\N	43 x 23 cm	198	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
910	17	La Niña! No Me Están Parando!	Acuarela y Tinta China sobre papel	\N	\N	2006	\N	\N	\N	32.5 × 47.5 cm	331	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
911	18	Serigrafía Vivencias del Pueblo Venta de Pollos en Paraguaychi	Tinta China sobre papel	\N	\N	1981	\N	\N	\N	23 x 34 cm	331	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
912	19	La Virgencita la Nuestra	Acuarela y Tinta China sobre papel	\N	\N	2010	\N	\N	\N	29 × 37 cm	331	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
913	20	Serigrafía el Castillo San Carlos de Borromeo	Acuarela Sobre Papel	\N	\N	2000	\N	\N	\N	21,5 x 32 cm	331	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
914	1	Mami Mi Sombrero	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	8	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
915	2	Pampatar Ciudad de Gaviotas	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	51	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
916	3	Conversando en Pampatar	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
917	4	Pampatar en Un Día Despejado	Creyones sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	65	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
918	5	La Caminería	Acuarela sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	85	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
919	6	Una Tarde en la Plaza	Creyones sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	90	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
920	7	Una Mañana en Pampatar	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	92	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
921	8	Empanadas Cochón	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	97	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
922	9	Alma del Muelle	Acuarela sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	121	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
923	10	Vista de Terraza del Castillo	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	142	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
924	11	Pueblo de la Sal	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	191	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
925	12	Bajo E' la Mata	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	208	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
926	13	Una Mirada A Pampatar	Creyón sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	54	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
927	14	Una Mirada Al Borromeo	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
928	15	Días en Pampatar	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	266	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
929	16	La Casa Rosada	Acuarela sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	275	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
930	17	El Rincón de las Empanadas	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	294	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
931	18	Conversando en Pampatar	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	297	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
932	19	Permanencia	Grafito sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	333	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
933	20	Iglesia Cristo del Buen Viaje	Mixta sobre papel	\N	\N	2022	\N	\N	\N	22.9 × 30.5 cm	334	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
934	1	La Basílica en Noviembre	Tinta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	269	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
935	2	El Rincón de los Jugos	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	297	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
936	3	Raspados	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	247	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
937	4	Recuerdo del Valle	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	51	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
938	5	Compremos Un Recuerdo	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	97	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
939	6	Vista A la Sierra	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	108	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
940	7	Empanadas	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	106	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
941	8	La Plaza	Grafito sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	95	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
942	9	Artesanos y Visitantes	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	294	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
943	10	Espiritu Natural	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	228	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
944	11	Camino de la Fe	Creyón sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	100	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
945	12	Milagro	Acuarela sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	186	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
946	13	Vista Desde la Plaza	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	92	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
947	14	Calle de los Artesanos	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	208	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
948	15	Bajo el Sol Vallero	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	238	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
949	16	Ventas	Grafito sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	79	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
950	17	Los Vende Flores	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	90	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
951	18	Valle Bonito	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
952	19	Plaza Insitu	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	81	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
953	20	Vendedora de Empanada	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	152	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
954	21	La Plaza del Valle	Mixta sobre Papel	\N	\N	2024	\N	\N	\N	22.7 x 30.5 cm	76	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
955	1	El Carpintero	Rapidograf sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	366	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
956	2	Mi Viejo Fogón	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	39	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
957	3	Frente A la Plaza	carboncillo sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	56	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
958	4	La Grea	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	76	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
959	5	Verdurero	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	81	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
960	6	Una Mañana en Tacarigua	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	92	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
961	7	El Jardin	Grafito sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	95	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
962	8	Vista Hacia la Montaña	mixta sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	97	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
963	9	Jardin Café	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	106	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
964	10	Plaza Corazón de Jesús	Tinta sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	122	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
965	11	Punto Tacariguero	Marcador sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	128	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
966	12	Iglesia de Tacarigua	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	367	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
967	13	El Frutero	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	157	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
968	14	12/04	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	186	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
969	15	Subiendo Tacarigua	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	191	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
970	16	La Casita de la Esquina	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	208	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
971	17	Comunidad	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	228	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
972	18	Donde Modesto	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	238	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
973	19	Vista A la Iglesia	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	78	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
974	20	Mañana Tacariguera	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	255	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
975	21	Mercado Tacariguero	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	368	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
976	22	El Protector de Tacarigua	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	269	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
977	23	El Encanto de Tacarigua	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	291	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
978	24	Casa de la Cultura	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	294	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
979	25	Corazón del Arte	Mixta Sobre Papel	\N	\N	2025	\N	\N	\N	30.5 x 22.9 cm	297	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
980	1	Terminal de Mulas	Mixta sobre papel	\N	\N	2024	\N	\N	\N	21 cm x 27,5	22	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
981	2	Mirador Puerto Rico	Tinta sobre papel	\N	\N	2024	\N	\N	\N	18.8x 27.5cm	27	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
982	3	La Vega	Grafito sobre papel	\N	\N	2024	\N	\N	\N	22,3 x 29,5 cm	37	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
983	4	Iglesia San Dionisio Desde el Paseo los Ilustres de Carora	Rapidografo/Cartulina	\N	\N	2023	\N	\N	\N	34.3 x 28 cm	45	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
984	5	Serigrafía Plaza Bolívar, el Hatillo	Acuarela sobre papel	\N	\N	1985	\N	\N	\N	30,2 x 22,8 cm	331	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
985	6	La Vecindad	Mixta sobre papel	\N	\N	1985	\N	\N	\N	30,2 x 22,8 cm	331	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
986	7	Esquina Tajamar	Acuarela sobre Papel	\N	\N	2025	\N	\N	\N	22.9 x 30.5 cm	355	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
987	8	Iglesia de la Pastora	Mixta sobre papel Craft	\N	\N	2025	\N	\N	\N	38 x 27,8 cm	49	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
988	9	Mercado del Campo Tacarigüero	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	22.9 x 30.5 cm	50	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
989	10	Vislumbrando el Horizonte Desde Mi Estancia en la Miranda	mixta sobre papel	\N	\N	2024	\N	\N	\N	22.9 x 30.5 cm	56	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
990	11	Dibujo Urbano Caracas	Tinta sobre papel	\N	\N	2025	\N	\N	\N	21 x 29.5 cm	362	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
991	12	Capilla Cruz Grande Restaurada	mixta sobre papel	\N	\N	2025	\N	\N	\N	40 x 30 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
992	13	Cae la Tarde en el Michelena	Mixta sobre canvas	\N	\N	2025	\N	\N	\N	28 x 21.5 cm	66	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
993	14	Un Lugar Grandioso en el Centro de Valencia	Grafito sobre papel	\N	\N	2024	\N	\N	\N	22.9 x 30.5 cm	77	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
994	15	Playa el Agua	acuarela sobre papel	\N	\N	2025	\N	\N	\N	21 x 29.5 cm	363	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
995	16	Ciudad Universitaria de Caracas	Mardores y Creyones sobre papel	\N	\N	2023	\N	\N	\N	28 x 21.5 cm	80	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
996	17	Pintando las Fachadas Coloniales de Mi Pueblo y Su Gente	Tinta china sobre papel	\N	\N	2021	\N	\N	\N	23x31cm	92	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
997	18	Calle Real Dese la Plaza	Mixta sobre papel	\N	\N	2025	\N	\N	\N	34,5 x 24.8 cm	356	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
998	19	Un Café con Vista A la Catedral	Acuarela sobre papel	\N	\N	2024	\N	\N	\N	22.9 x 30.5 cm	97	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
999	20	Plaza de la Pastora	Mixta sobre papel	\N	\N	2025	\N	\N	\N	24.8 x 18.5 cm	111	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1000	21	El Oeste de Caracas	Mixto sobre papel	\N	\N	2023	\N	\N	\N	22.7 x 30.5 cm	161	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1001	22	Guaraira Repano, Esquina el Cristo	Mixta sobre papel	\N	\N	2024	\N	\N	\N	22.9 x 30.5 cm	172	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1002	23	La Llegada A Caño Amarillo	mixta sobre papel	\N	\N	2024	\N	\N	\N	21.3 x 27.5 cm	184	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1003	24	La Pastora en 3 Escenas	Mixta sobre canvas	\N	\N	2025	\N	\N	\N	28 x 21.5 cm	358	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1004	25	Puente de Alta Vista	Tinta y acuarela sobre papel	\N	\N	2023	\N	\N	\N	30.5 x 22.9 cm	193	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1005	26	Museo Michelena Esq. de Urapal	Mixta sobre Papel	\N	\N	2025	\N	\N	\N	22.9 x 30.5 cm	359	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1006	27	Pueblo en Soledad	Tinta sobre papel	\N	\N	2022	\N	\N	\N	28x21.5cm	237	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1007	28	Historia de Perucho	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	31.5 x 21.7 cm	247	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1008	29	Un Lugar Mágico y de Paz	Acuarela y marcadores sobre papel	\N	\N	2023	\N	\N	\N	22.7 x 29 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1009	30	Paseo Anauco	Acuarela sobre papel	\N	\N	2024	\N	\N	\N	22.9 x 30.5 cm	257	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1010	31	Esquina Oeste 10	Boligrafo sobre Papel	\N	\N	2025	\N	\N	\N	28.8 x 22.9	35	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1011	32	La Vega de San Isidro	mixta sobre papel	\N	\N	2024	\N	\N	\N	24.2x16.3cm	287	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1012	33	Caracas en Gouache , la Pastora	Acuarela y Gouache sobre papel	\N	\N	2025	\N	\N	\N	32,3 x 25 cm	360	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1013	34	En Armonia con la Naturaleza Ii	Mixta sobre papel	\N	\N	2024	\N	\N	\N	30,5 x 22,8 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1014	1	Terminal de Mulas	Mixta sobre papel	\N	\N	2025	\N	\N	\N	\N	22	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1015	2	Mirador Puerto Rico	Tinta sobre papel	\N	\N	2025	\N	\N	\N	\N	27	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1016	3	La Vega	Grafito sobre papel	\N	\N	2025	\N	\N	\N	\N	37	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1017	4	Iglesia San Dionisio Desde el Paseo los Ilustres de Carora	Rapidografo/Cartulina	\N	\N	2025	\N	\N	\N	\N	45	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1018	5	Serigrafía Plaza Bolívar, el Hatillo	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	\N	331	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1019	6	Esquina Tajamar	Acuarela sobre Papel	\N	\N	2025	\N	\N	\N	\N	355	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1020	7	Iglesia de la Pastora	Mixta sobre papel Craft	\N	\N	2025	\N	\N	\N	\N	49	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1021	8	Mercado del Campo Tacarigüero	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	\N	50	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1022	9	Vislumbrando el Horizonte Desde Mi Estancia en la Miranda	mixta sobre papel	\N	\N	2025	\N	\N	\N	\N	56	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1023	10	Cae la Tarde en el Michelena	Mixta sobre canvas	\N	\N	2025	\N	\N	\N	\N	66	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1024	11	Un Lugar Grandioso en el Centro de Valencia	Grafito sobre papel	\N	\N	2025	\N	\N	\N	\N	77	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1025	12	Ciudad Universitaria de Caracas	Mardores y Creyones sobre papel	\N	\N	2025	\N	\N	\N	\N	80	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1026	13	Pintando las Fachadas Coloniales de Mi Pueblo y Su Gente	Tinta china sobre papel	\N	\N	2025	\N	\N	\N	\N	92	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1027	14	Calle Real Dese la Plaza	Mixta sobre papel	\N	\N	2025	\N	\N	\N	\N	356	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1028	15	Vista Hacia la Montaña	mixta sobre papel	\N	\N	2025	\N	\N	\N	\N	97	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1029	16	Plaza de la Pastora	Mixta sobre papel	\N	\N	2025	\N	\N	\N	\N	111	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1030	17	El Frutero	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	\N	157	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1031	18	El Oeste de Caracas	Mixto sobre papel	\N	\N	2025	\N	\N	\N	\N	161	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1032	19	Concurso Fundastohr 2023 el Valle Espiritu Santo. Isla de Margarita	Fotografía	\N	\N	2025	\N	\N	\N	\N	357	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1033	20	Concurso Fundastohr 2023 el Valle Espiritu Santo. Isla de Margarita	Fotografía	\N	\N	2025	\N	\N	\N	\N	357	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1034	21	Concurso Fundastohr 2023 el Valle Espiritu Santo. Isla de Margarita	Fotografía	\N	\N	2025	\N	\N	\N	\N	357	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1035	22	Guaraira Repano, Esquina el Cristo	Mixta sobre papel	\N	\N	2025	\N	\N	\N	\N	172	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1036	23	La Llegada A Caño Amarillo	mixta sobre papel	\N	\N	2025	\N	\N	\N	\N	184	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1037	24	La Pastora en 3 Escenas	Mixta sobre canvas	\N	\N	2025	\N	\N	\N	\N	358	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1038	25	Puente de Alta Vista	Tinta y acuarela sobre papel	\N	\N	2025	\N	\N	\N	\N	193	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1039	26	Museo Michelena Esq. de Urapal	Mixta sobre Papel	\N	\N	2025	\N	\N	\N	\N	359	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1040	27	Comunidad	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	\N	228	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1041	28	Pueblo en Soledad	Tinta sobre papel	\N	\N	2025	\N	\N	\N	\N	237	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1042	29	Samuelalmau@gmail.com	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	\N	247	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1043	30	Un Lugar Mágico y de Paz	Acuarela y marcadores sobre papel	\N	\N	2025	\N	\N	\N	\N	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1044	31	Paseo Anauco	Acuarela sobre papel	\N	\N	2025	\N	\N	\N	\N	257	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1045	32	Esquina Oeste 10	Boligrafo sobre Papel	\N	\N	2025	\N	\N	\N	\N	35	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1046	33	La Vega de San Isidro	mixta sobre papel	\N	\N	2025	\N	\N	\N	\N	287	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1047	34	Caracas en Gouache , la Pastora	Acuarela y Gouache sobre papel	\N	\N	2025	\N	\N	\N	\N	360	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1048	1	Sra Lavando (pedro Gonzalez)	Tinta china y aguada sobre papel	\N	\N	2019	\N	\N	\N	23cm x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1049	2	Peché, Hacedor de Instrumentos (la Vecindad)	Tinta china y aguada sobre papel	\N	\N	2019	\N	\N	\N	23cm x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1050	3	Ambiente Insular	Tinta china y Aguada sobre papel	\N	\N	2019	\N	\N	\N	23cm x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1051	4	Morada de Un Pescador (el Guamache)	tinta y aguada sobre papel	\N	\N	2019	\N	\N	\N	23cm x 31 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1052	5	Plaza de Santa Ana (santa Ana)	Tinta y aguada sobre papel	\N	\N	2019	\N	\N	\N	23cm x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1053	6	Venta de Chicharrón (tacarigua)	Tinta sobre papel	\N	\N	2019	\N	\N	\N	28cm x 22cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1054	7	Venta de Chinchorros (tacarigua)	Tinta sobre papel	\N	\N	2019	\N	\N	\N	28cm x 22cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1055	8	Vendiendo Cualquier Cosa (juan Griego)	Tinta sobre papel	\N	\N	2019	\N	\N	\N	28cm x 22cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1056	9	Restorant (juan Griego)	Tinta sobre papel	\N	\N	2019	\N	\N	\N	28cm x 22cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1057	10	Casa Colonial (santa Ana)	Tinta sobre papel	\N	\N	2019	\N	\N	\N	28x 22cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1058	11	Desde la Distancia (la Sierra)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	30.5x 45.7cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1059	12	Fachadas de Tacarigua (tacarigua)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	30.5x 45.7cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1060	13	Bahía de Juan Griego (juan Griego)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	30.5 x 45.7cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1061	14	Crepúsculo (juan Griego)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	30.5 x 45.7cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1062	15	Agua Bendita	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	30.5 x 45.7cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1063	16	Fachadas de la Asunción	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23 x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1064	17	La Típica (tacarigua)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23 x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1065	18	Emprendiendo en Mi Pueblo (tacarigua)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23 x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1066	19	Fachadas de Santa Ana	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1067	20	Fachadas de la Vecindad	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23 x 31 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1068	21	Muelle de Juan Griego	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23 x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1069	22	En Reposo (juan Griego)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23 x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1070	23	Echando la Conversa (juan Griego)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23 x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1071	24	Titanes de Chacaracual (macanao)	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1072	25	Virgen del Valle	Acuarela sobre papel	\N	\N	2019	\N	\N	\N	23 x 31cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1094	1	Basílica Menor Virgen del Valle	Gouache y tinta china  sobre papel	\N	\N	2023	\N	\N	\N	26 x 36 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1095	2	Castillo San Carlos Borromeo	Acuarela y tinta sobre papel	\N	\N	2023	\N	\N	\N	21 x 29.7 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1096	3	Cerro Copey	Acuarela y tinta sobre papel	\N	\N	2023	\N	\N	\N	22.9 x 29.5 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1097	4	Cerro Matasiete	Gouache y tinta china  sobre papel	\N	\N	2023	\N	\N	\N	26 x 36 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1098	5	Fondeadero	Acuarela y tinta sobre papel	\N	\N	2023	\N	\N	\N	22.9 x 30.5 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1099	6	Julia Restaurant	Acuarela y tinta sobre papel	\N	\N	2023	\N	\N	\N	22.9 x 30.5 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1073	1	Fondeadero	Acuarela y tinta sobre papel	22.90	30.50	2022	\N	\N	\N	Obra Ganadora del Concurso Fundastohr 2022	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1100	7	Pez Catire Rayado	Gouache y tinta china  sobre papel	\N	\N	2023	\N	\N	\N	22.9 x 30.5 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1101	8	Pez León	Gouache y tinta china  sobre papel	\N	\N	2023	\N	\N	\N	22.9 x 30.5 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1102	9	Playa de Pampatar	Acuarela y tinta sobre papel	\N	\N	2023	\N	\N	\N	21 x 29.7 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1103	10	Rio Sambil Margarita	Gouache y tinta china sobre papel	\N	\N	2023	\N	\N	\N	26 x 36 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1104	11	Ruina de Telecaribe	Acuarela y tinta sobre papel	\N	\N	2023	\N	\N	\N	22.9 x 30.5 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1105	12	Unversidad de Margarita	Acuarela y tinta sobre papel	\N	\N	2023	\N	\N	\N	22.9 x 30.5 cm	59	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1106	1	Foto en la Basílica	acuarela y tinta	\N	\N	2023	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1107	2	La Primera Ola	acuarela	\N	\N	2024	\N	\N	\N	5x45 cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1108	3	Baño en Playa Guacuco	acuarela	\N	\N	2023	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1109	4	Castillos de Arena	acuarela	\N	\N	2024	\N	\N	\N	5x45cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1110	5	Crepúsculo en Playa Concord	acuarela	\N	\N	2023	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1111	6	Danza Al Atardecer	acuarela	\N	\N	2024	\N	\N	\N	5x45cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1112	7	Día de Blancos	acuarela y creyones	\N	\N	2023	\N	\N	\N	9x30	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1113	8	El Desayuno de las Cabras	acuarela	\N	\N	2024	\N	\N	\N	5x45cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1114	9	El Portón y las Trinitarias	acuarela	\N	\N	2024	\N	\N	\N	5x45cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1115	10	Flamingos en la Laguna del Morro	acuarela	\N	\N	2024	\N	\N	\N	5x45cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1116	11	La Melusina de Porlamar	acuarela	\N	\N	2024	\N	\N	\N	5x45cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1117	12	Nadando con Tortugas	acuarela	\N	\N	2024	\N	\N	\N	5x45cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1118	13	El Maestro “beto” Valderrama	acuarela	\N	\N	2024	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1119	14	Lourdes Maria Brito	acuarela y tinta	\N	\N	2023	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1120	15	Pelícanos en la Faena	acuarela	\N	\N	2023	\N	\N	\N	9x30	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1121	16	Pitigüeys	acuarela	\N	\N	2023	\N	\N	\N	9x30	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1122	17	El Primer Baño	acuarela	\N	\N	2024	\N	\N	\N	5x45cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1123	18	Cloé	acuarela	\N	\N	2024	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1124	19	Gal	acuarela	\N	\N	2024	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1125	20	Cali	acuarela	\N	\N	2024	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1126	21	Benjamin	acuarela	\N	\N	2024	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1127	22	Héroes	grafito, grafito	\N	\N	2022	\N	\N	\N	5x28 cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1128	23	Niños	grafito	\N	\N	2022	\N	\N	\N	5x24 cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1129	24	Aguaclara	acuarela	\N	\N	2024	\N	\N	\N	5x51 cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1130	25	Isla Para Dos	acuarela	\N	\N	2024	\N	\N	\N	5x51 cm	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1131	26	Regreso Al Paraíso	\N	\N	\N	2024	\N	\N	\N	55x 36	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1132	27	Portada de la "bruja de la Cueva"	digital	\N	\N	2023	\N	\N	\N	\N	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1133	28	Pequeña Bailarina	acuarela y creyon	\N	\N	2024	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1134	29	Pequeña Guaricha	acuarela y creyon	\N	\N	2024	\N	\N	\N	5x22	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1135	30	Chica Harina Pan	digital	\N	\N	2021	\N	\N	\N	\N	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1136	31	Río	digital	\N	\N	2021	\N	\N	\N	\N	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1137	32	Frutal	digital	\N	\N	2021	\N	\N	\N	\N	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1138	33	Ursula	digital	\N	\N	2021	\N	\N	\N	\N	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1139	34	Pequeña Sirenita	digital	\N	\N	2021	\N	\N	\N	\N	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1140	35	Sirenita Cereza	digital	\N	\N	2021	\N	\N	\N	\N	62	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1141	1	En Armonía con la Naturaleza	Mixta sobre papel	\N	\N	2024	\N	\N	\N	30.5 x 45.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1142	2	Imaginario de Mi Infancia	Tinta sobre papel	\N	\N	2024	\N	\N	\N	30.5 x 45.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1143	3	Montaña Imaginaria	Pastel al óleo sobre papel	\N	\N	2024	\N	\N	\N	23  x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1144	4	El Hogar Que Era y el Que Será	Pastel al Óleo sobre papel	\N	\N	2024	\N	\N	\N	23  x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1145	5	Nueva Esparta Viva	Pastel al Óleo sobre papel	\N	\N	2024	\N	\N	\N	23  x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1146	6	En Armonía con la Naturaleza Ii	Tinta sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1147	7	Creación de la Naturaleza Vs Creación del Hombre	Tinta sobre papel	\N	\N	2024	\N	\N	\N	23  x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1148	8	Casa de Mis Abuelos	Tinta sobre papel	\N	\N	2024	\N	\N	\N	23 x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1149	9	Hogar, Dulce Hogar	Tinta sobre papel	\N	\N	2024	\N	\N	\N	23  x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1150	10	Casa de Mi Mamá	Tinta sobre papel	\N	\N	2024	\N	\N	\N	23  x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1151	11	Rancho de Mi Abuelo	Tinta sobre papel	\N	\N	2024	\N	\N	\N	23 x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1152	12	En Armonía con la Naturaleza Iii	Mixta sobre papel	\N	\N	2024	\N	\N	\N	23 x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1153	13	Camino A Casa	Mixta sobre papel	\N	\N	2024	\N	\N	\N	23 x 30.5 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1154	14	Mi Abuela Gisela	Mixta sobre papel	\N	\N	2024	\N	\N	\N	11.5 x 15.1 cm	295	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1155	1	La Empanadera Rosaura	Mixta sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1156	2	Momentos en Santa Ana	Mixta sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1157	3	Careneros	Grafito sobre papel	\N	\N	2024	\N	\N	\N	21.6 x 27.9 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1158	4	Tiempos Que No Volverán	Mixta sobre papel	\N	\N	2024	\N	\N	\N	21.6 x 27.9 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1159	5	Vista de la Galera	Tinta sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1160	6	Principiante del Pescador	Tinta sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1161	7	Cayena	Pastel al óleo sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1162	8	Bastón	Pastel al óleo sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1163	9	Orquídeas	Pastel al óleo sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1164	10	Coquetas	Pastel al óleo sobre papel	\N	\N	2024	\N	\N	\N	22.8 x 30.5 cm	251	2026-10-13 03:39:35.976271	2026-10-13 03:39:35.976271
1	4687	Nuestra virgencita del valle	Acuarela y Tinta China sobre papel	23.50	32.50	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
2	4878	La virgencita la nuestra	Acuarela y Tinta China sobre papel	29.00	37.00	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
3	5534	Obituario virgen del valle	Tinta sobre papel	30.00	23.00	2012	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
4	4693	La virgen del valle	Acuarela y Tinta China sobre papel	21.00	29.50	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
5	4698	Tributo a la virgen	Acuarela y Tinta China sobre papel	27.00	37.00	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
6	4876	Nuestra Margariteña	Acuarela y Tinta China sobre papel	37.50	32.50	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
7	5029	La Virgen y El Ángel	Acuarela y Tinta China sobre papel	38.50	38.00	2011	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
8	4695	La Virgen a Diario	Acuarela y Tinta China sobre papel	21.00	29.50	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
9	4696	Me encomendé a la Virgen	Acuarela y Tinta China sobre papel	23.50	32.00	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
10	S/N	Sin nombre. (Virgen del valle sobre estampillas de Venezuela)	Tinta china sobre Estampillas en cartón	27.00	35.00	1998	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
11	5861	La virgen en el Guayamuri	tinta china sobre papel	30.00	42.00	2016	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
12	5865	La virgen y su pueblo minero	tinta sobre papel	30.00	42.00	2016	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
13	5856	La virgen y el guayamuri	tinta sobre papel	30.00	42.00	2016	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
14	4743	Margarita es entre nosotros, la virgen, el guayamuri y el pescado	Acuarela y Tinta China sobre papel	45.00	32.00	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
15	4632	Protegidos bajo su manto	Acuarela y Tinta China sobre papel	25.00	34.00	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
16	4911	Torres en Margarita	Acuarela y Tinta China sobre papel	32.00	45.50	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
17	1827	La virgen marinera	Acuarela y Tinta China sobre papel	29.50	42.50	1999	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
18	4864	Margarita es...	Acuarela y Tinta China sobre papel	32.00	44.50	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
19	2246	La Virgen de Margarita	Tinta sobre papel	34.50	41.00	2001	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
20	4730	La bendición de la faena	Acuarela y Tinta China sobre papel	32.00	45.50	2010	Virgen Del Valle	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
21	5554	Pecementason	Acuarela y Tinta China sobre papel	21.50	31.00	2014	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
22	5537	Tiraneras	tinta china sobre papel	26.50	35.50	2014	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
23	4888	Motivo pescador	Acuarela sobre papel	25.00	34.00	2010	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
24	1767	Mercado de pescado por la Mar viejo muelle  año 1957	Grafito sobre papel	24.00	33.00	1998	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
25	2029	La isleta en 1980	Grafito sobre papel	23.50	29.50	1999	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
26	4327	La hija de la panadera come un mango	tinta china sobre papel	23.00	30.50	2009	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
27	2384	Y todos comen	Acuarela y Tinta China sobre papel	24.00	31.50	2000	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
28	2241	A quién le tocará Aura	Acuarela sobre papel	23.50	31.50	2001	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
29	24??	Halek nos llenó con cables el hombre de la Mar n	Acuarela y Tinta China sobre papel	24.00	32.00	1999	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
30	2237	El encuentro	Acuarela sobre papel	28.00	31.50	2001	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
31	2110	La cueva del bufón número	Acuarela sobre papel	24.00	31.50	2000	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
32	4831	Pescadores número	Acuarela sobre papel	23.50	31.50	2010	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
33	5827	amanecer tiradero número 5827	Acuarela sobre papel	22.00	30.00	2016	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
34	4922	En celo?	Acuarela sobre papel	29.50	23.00	2011	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
35	3863	Pescadora en 1500	Acuarela y Tinta China sobre papel	20.50	20.50	2009	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
36	1107	Farol azul	Acuarela y Tinta China sobre papel	21.00	30.00	1993	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
37	4482	Apunte de una playa	Tinta sobre papel	30.50	21.50	2009	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
38	2828	El tirano en 1984	tinta china sobre papel	21.00	25.00	2004	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
39	4972	Pesca simulada	Acuarela sobre papel	23.50	32.00	2011	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
40	2226	Nada es demasiado pesado	Acuarela y Tinta China sobre papel	28.00	35.00	2000	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
41	5047	Se lo llevará en hombros	Acuarela y Tinta China sobre papel	28.00	38.00	2011	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
42	1148	Comparte la pesca	Acuarela sobre papel	39.50	30.00	1993	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
43	2106	El pajarraco está pendiente	Acuarela sobre papel	28.50	39.50	2000	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
44	2047	Los hombres sobre el lomo las mujeres en la cabeza Pampatar	Grafito sobre papel	40.50	28.50	1999	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
45	1930	El hombre de la mar en el tirano	Acuarela y Tinta China sobre papel	30.00	42.00	1999	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
46	4980	Capaya pesquera	Acuarela sobre papel	29.50	40.50	2011	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
47	4913	La vendedora de pescado	Acuarela sobre papel	31.50	45.00	2010	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
48	4891	La compañera sigue conmigo	Acuarela sobre papel	30.00	45.50	2010	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
49	3413	La niña! No me están parando cierra!	Acuarela y Tinta China sobre papel	32.50	47.50	2006	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
50	4866	La vendedora de pescado	Acuarela sobre papel	32.00	43.00	2010	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
51	1196	Fosforescente número 1196	Acuarela y Tinta China sobre papel	34.00	49.00	1994	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
52	4893	El hombre de la Mar	Acuarela sobre papel	45.50	30.00	2010	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
53	4697	Pescadores	Acuarela sobre papel	40.50	30.00	2011	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
54	4987	Pescadores	Acuarela sobre papel	40.50	30.00	2011	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
55	4436	Pescadores	Acuarela sobre papel	27.00	35.00	2009	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
56	1113	Pajarraco curioso	Acuarela sobre papel	27.00	33.50	1993	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
57	2227	Con sus protagonistas	Acuarela sobre papel	30.00	42.00	2000	Pescadores	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
58	5469	Recordando a Reverón, Bote en la bahia del tirano con el Guayamurí	Acuarela sobre papel	21.50	28.00	2003	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
59	1087	Juan griego	Sanguina sobre papel	22.50	30.50	1993	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
60	3946	El vichar Isla de coche	Sanguina sobre papel	30.00	23.00	\N	Paisajes y Pueblos de Margarita	\N	Caracas	sin firma	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
61	1805	Mercado de porlamar	Grafito sobre papel	28.00	34.50	1999	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
62	2062	Manzanillo	Grafito sobre papel	35.50	28.00	1993	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
63	1998	El maco número	Tinta sobre papel	29.00	41.00	1999	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
64	4654	Apunte casa parroquial de 1964 la Asunción	Grafito sobre papel	31.00	20.00	2010	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
65	3593	Con DNI	Grafito sobre papel	33.00	23.00	2006	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
66	1897	Consejo en la Asunción	Grafito sobre papel	30.50	24.50	1984	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
67	5741	Tacarigua frente a la casa de la cultura	Acuarela sobre papel	28.00	21.50	2000	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
68	5707	Coche en el 1978	Grafito sobre papel	21.50	30.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
69	5706	El tirano 1979	Grafito sobre papel	21.00	30.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
70	5736	El teléfono de los Salazares en el salado 1989	Tinta sobre papel	23.50	16.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
71	5730	Museo de caserío la mira 1990	Grafito sobre papel	22.00	16.00	2013	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
72	289	Porlamar año 1957	Tinta sobre papel	21.00	18.00	1984	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
73	5737	Antes de llegar al bar tropical 1977	Tinta sobre papel	25.50	17.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
74	1862	Punta de piedra	Grafito y acuarela sobre papel	32.00	24.00	1999	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
75	2074	Playa de Pedro González bodega en 1984	Grafito sobre papel	24.00	31.50	1999	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
76	1891	El reloj solar la Asunción número 1891 técnica grafito sobre el papel dimensión 27 × 35 cm año 1992	Grafito sobre papel	27.00	35.00	1992	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
77	3120	En Fuentidueña	Grafito sobre papel	21.50	25.50	2000	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
78	3292	Castillo de Santa Rosa baile del Carite número 3292 técnica tinta sobre papel dimensión 21.5 × 12 cm año 2005	Tinta sobre papel	21.50	12.00	2005	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
79	162	Apunte viejo puente colonial la asunción	Grafito y acuarela sobre papel	30.00	39.00	1970	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
80	5847	Paraguachí	Tinta sobre papel	28.00	34.00	2016	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
81	3693	Isla de coche apunte	tinta china sobre papel	35.50	23.50	1984	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
82	2408	La Asunción	Grafito sobre papel	21.00	29.50	2002	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
83	5740	Tacarigua	Grafito sobre papel	25.00	18.50	2002	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
84	5715	La Aguada	tinta china sobre papel	21.50	28.00	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
131	3257	Apunte enfrentando Gallos	Tinta sobre papel	18.00	22.00	2005	Animales	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
85	4564	Cuando asaltaron el acceso a los Gómez por la década de los 80	tinta china sobre papel	39.50	29.00	2010	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
86	5552	Proyecto gran hotel con Dancing París	tinta china sobre papel	28.00	33.50	2013	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
87	606	El cercado	tinta china sobre papel	31.50	21.50	1988	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
88	315	Vivencia rural todos conviven	tinta china sobre papel	29.50	22.00	\N	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
89	455	la vecindad los repelladores	tinta china sobre papel	31.50	21.50	1986	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
90	5720	Pueblos de Margarita Taguantar	tinta china sobre papel	30.50	21.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
91	5721	Museo pueblos de Margarita Taguantar	tinta china sobre papel	30.50	21.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
92	5722	Pueblos de Margarita  Taguantar	tinta china sobre papel	30.50	21.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
93	5738	Pueblos de Margarita  Taguantar	tinta china sobre papel	30.50	21.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
94	5739	Pueblos de Margarita  Taguantar	tinta china sobre papel	30.50	21.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
95	4105	Pueblos de Margarita  Taguantar	tinta china sobre papel	30.50	21.50	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
96	5766	Hotel Costa linda entrada	Acuarela y Tinta China sobre papel	21.50	28.00	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
97	5763	Hotel Costa linda área de bar	Acuarela y Tinta China sobre papel	21.50	28.00	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
98	5762	Hotel Costa linda área de jardín	Acuarela y Tinta China sobre papel	21.50	28.00	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
99	5761	Hotel Costa linda pasillo a la entrada	Acuarela y Tinta China sobre papel	21.50	28.00	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
100	5767	Hotel Costa linda vista hacia la edificación	Acuarela y Tinta China sobre papel	21.50	28.00	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
101	5764	Hotel Costa linda área de jardín	Acuarela y Tinta China sobre papel	21.50	28.00	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
102	5765	Hotel Costa linda caminaría hacer las habitaciones	Acuarela y Tinta China sobre papel	21.50	28.00	2014	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
103	1754	Iglesia San Nicolas de bari Porlarmar en 1973	Grafito sobre papel	24.00	32.50	1993	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
104	2937	Casa de Victor Moya en San Sebastián en 1973	tinta china sobre papel	28.50	23.00	2003	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
105	4571	En Boca del Río en 1980	tinta china sobre papel	22.00	28.00	2010	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
106	450	Puisito número 450 copia	tinta china sobre papel	31.50	21.50	1986	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
107	5851	Las Tetas de María Guevara	Tinta sobre papel	72.00	22.00	2016	Paisajes y Pueblos de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
108	4817	Tejedora de hamacas apunte	Grafito sobre papel	29.50	40.50	2010	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
109	2913	El pez sapo	tinta china sobre papel	33.00	24.00	2000	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
110	4805	Esperanza Atarraya	Grafito sobre papel	30.00	40.50	2010	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
111	4420	Tu y yo para siempre	tinta china sobre papel	23.00	32.00	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
112	3791	Mamá me hace la clineja	tinta china sobre papel	25.00	32.00	2007	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
113	4445	La negra con un boca plato	tinta china sobre papel	28.00	34.50	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
114	4984	Recordando a Pablo Casals	Acuarela y Tinta China sobre papel	29.50	37.50	2011	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
115	4497	El voto directo 4497	tinta china sobre papel	32.00	23.50	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
116	4443	Maternidad	tinta china sobre papel	23.50	32.00	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
117	4459	La sirena Vanesa	tinta china sobre papel	28.00	34.50	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
118	4486	Mi bebé 4486 técnica tinta china sobre papel dimensión 30 × 41 cm año 2009	tinta china sobre papel	30.00	41.00	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
119	4480	La modelo 4480 técnica tinta china sobre papel dimensión 30 × 41 cm año 2009	tinta china sobre papel	30.00	41.00	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
120	4434	Desnudo 4434 técnica tinta china sobre papel dimensión 34.5 × 28 cm año 2009	tinta china sobre papel	34.50	28.00	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
121	4819	Medio kilo de estopa número 4819 técnica tinta china sobre papel dimensión 32 × 44.5 cm año 2010	tinta china sobre papel	32.00	44.50	2010	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
122	4448	La sirena 4448 técnica tinta china sobre papel dimensión 28 × 34.5 cm año 2009	tinta china sobre papel	28.00	34.50	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
123	4446	El andino número 4446 técnica tinta china sobre papel di mención 28 × 34.5 año 2009	tinta china sobre papel	28.00	34.50	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
124	4816	Se presentaron de repente	Grafito sobre papel	40.50	30.00	2010	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
125	4486	Sí hay pescado	tinta china sobre papel	23.50	32.00	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
126	4498	La cita	tinta china sobre papel	32.00	45.00	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
127	4491	Chequeo médico	tinta china sobre papel	29.50	41.00	2009	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
128	4820	Sueño de muchos	tinta china sobre papel	30.00	41.00	2010	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
129	4915	Amor incondicional	tinta china sobre papel	32.00	47.00	2010	\N	Un solo trazo	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
130	5433	El verdadero amigo	Acuarela y Tinta China sobre papel	29.50	20.50	2013	Animales	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
132	4066	Los gallitos de piedra	Oil Pastel sobre papel	23.50	32.00	2008	Animales	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
133	5439	Miradas que hablan	Acuarela y Tinta China sobre papel	18.50	27.00	2013	Animales	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
134	5437	La gata consentida	Acuarela y Tinta China sobre papel	19.50	29.50	2013	Animales	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
135	537	Lo que sucedió a Restitoto el Mira muertos	tinta china sobre papel	31.50	25.00	1988	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
136	5709	Oración de los animales	tinta china sobre papel	21.50	28.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
137	5716	El espanto	tinta china sobre papel	21.50	28.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
138	5716	El cantor de galerones	tinta china sobre papel	21.50	28.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
139	5714	Los cuentos de naturaleza	tinta china sobre papel	21.50	28.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
140	5712	Fermín apareció	tinta china sobre papel	21.50	28.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
141	5713	El tesoro de Fermín	tinta china sobre papel	21.50	28.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
142	5711	Las Peyrollaz de plata	tinta china sobre papel	21.50	28.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
143	1000	1000 años es un día	tinta china sobre papel	21.50	28.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
144	5556	La margarita condón Heraclio	tinta china sobre papel	28.00	34.00	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
145	5030	Me tropecé con la chinigua	Acuarela sobre papel	32.50	46.50	2014	Mitos y creencias Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
146	4854	Apunte CS Praga	Grafito sobre papel	32.50	46.50	2010	Apunte	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
147	4855	Apunte	Grafito sobre papel	27.00	36.50	2010	Apunte	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
148	3932	La familia Mariana	Acuarela sobre papel	21.50	30.50	2007	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
149	4846	Adivine	Acuarela sobre papel	21.50	30.50	\N	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
150	4820	Guaraira Repano	Acuarela sobre papel	28.50	21.00	2010	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
151	23	Pajarraco	Acuarela sobre papel	23.50	32.00	2010	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
152	1924	Margarita	Acuarela sobre papel	31.50	24.00	1993	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
153	4939	Cisne	Acuarela sobre papel	28.00	22.00	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
154	3524	El hombre del mar moderno	Grafito y acuarela sobre papel	19.50	27.50	2006	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
155	4944	Cockpit en un F1	Acuarela y Tinta China sobre papel	21.50	28.00	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
156	4836	Papel de pruebas	Acuarela y Tinta China sobre papel	21.00	28.50	2010	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
157	3821	Ovulación	tinta china sobre papel	23.50	32.00	2007	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
158	3819	Orgasmo	tinta china sobre papel	24.00	33.00	2007	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
159	3789	Amamantando	Acuarela y Tinta China sobre papel	24.00	30.50	2007	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
160	4927	El esquimal	Acuarela y Tinta China sobre papel	20.50	29.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
161	4943	Jamón serrano	Acuarela y Tinta China sobre papel	21.50	28.00	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
162	4925	La cita secreta	Acuarela sobre papel	21.50	30.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
163	4442	El rey	Acuarela y Tinta China sobre papel	20.00	29.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
164	4940	vida submarina	Acuarela y Tinta China sobre papel	21.50	28.00	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
165	4921	Edificio en construcción	Acuarela y Tinta China sobre papel	21.50	30.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
166	4848	En pleno vuelo	Acuarela y Tinta China sobre papel	23.50	32.50	2010	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
167	2091	Caperucita roja y el lobo	Acuarela y Tinta China sobre papel	35.50	28.00	2000	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
168	4937	India con su bebé	Acuarela y Tinta China sobre papel	21.50	28.00	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
169	3793	Pescadores	Acuarela sobre papel	32.00	23.50	2007	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
170	4837	Pescador	Acuarela y Tinta China sobre papel	22.00	30.00	2010	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
171	4833	Sorprendido	Acuarela y Tinta China sobre papel	32.00	44.00	2010	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
172	4936	Mamá chimpancé	Acuarela y Tinta China sobre papel	21.50	30.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
173	2094	Margarita	Acuarela y Tinta China sobre papel	21.50	28.00	2000	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
174	4172	Vegetación	Oil Pastel sobre papel	32.00	47.00	2008	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
175	1999	El deslave en el litoral diciembre 1999	Acuarela y Tinta China sobre papel	42.00	30.00	2000	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
176	2092	Maternidad	Acuarela y Tinta China sobre papel	35.50	28.00	2000	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
177	4971	Amanecer tiranero	Acuarela sobre papel	32.00	45.00	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
178	5015	Fiesta playera	Acuarela y Tinta China sobre papel	33.00	45.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
179	4969	Venta de pescado en el bote	Acuarela sobre papel	32.00	45.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
180	4818	El político	Acuarela y Tinta China sobre papel	32.00	44.00	2010	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
181	4926	Comprar un pescado	Acuarela y Tinta China sobre papel	32.50	46.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
182	3820	Cuatro varones y las Morochas	tinta china sobre papel	30.00	39.50	2007	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
183	4350	La quema	Acuarela sobre papel	32.50	40.00	2009	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
184	5009	Cara de burro embarcado	Acuarela y Tinta China sobre papel	32.50	45.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
185	4452	Consecuencias de la polución	Acuarela y Tinta China sobre papel	28.00	34.50	2009	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
186	4993	Feliz cumpleaños mi amor	Acuarela y Tinta China sobre papel	22.00	30.00	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
187	4400	Se me ocurrió	tinta china sobre papel	32.00	45.00	2009	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
188	S/N	Sin nombre madre e hija	tinta china sobre papel	21.50	28.00	2013	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
189	S/N	Sin nombre músico	Acuarela y Tinta China sobre papel	21.50	28.00	2013	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
190	S/N	Sin nombre músico	Acuarela y Tinta China sobre papel	21.50	28.00	2013	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
191	4941	Tango	Acuarela y Tinta China sobre papel	22.00	30.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
192	4992	El parrandero	Acuarela y Tinta China sobre papel	22.00	30.00	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
193	4938	Ladrón nocturno	Acuarela y Tinta China sobre papel	21.50	30.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
194	4531	Cardumen	Acuarela y Tinta China sobre papel	43.50	29.00	2009	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
195	3410	El beso abstracto	tinta china sobre papel	25.00	32.00	2006	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
196	4832	Embarcado	Acuarela y Tinta China sobre papel	31.50	46.00	2010	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
197	4924	Las señoritas	Acuarela y Tinta China sobre papel	21.50	30.50	2011	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
198	5553	La vende pescado	Acuarela y Tinta China sobre papel	20.50	29.50	2014	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
199	5550	El Guayamorí	Acuarela y Tinta China sobre papel	22.50	31.50	2014	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
200	5742	JurunGando la basura	Acuarela sobre papel	22.00	27.00	2014	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.694339	2026-10-13 01:32:13.694339
201	5744	El nadador	Acuarela y Tinta China sobre papel	21.50	28.00	2014	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
202	5745	Parrandero	Acuarela y Tinta China sobre papel	21.50	28.00	2014	\N	C.S. Praga	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
203	5374	cuando sea grande seré rica	Acuarela y Tinta China sobre papel	20.00	29.50	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
204	4603	Ah pues no me obedecen	Acuarela y Tinta China sobre papel	21.00	29.50	2010	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
205	4725	Se adoran	Acuarela sobre papel	24.50	31.50	2010	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
206	4708	Maternidad	Acuarela sobre papel	24.50	31.50	2010	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
207	5440	Nietzsche Mientras más…	Acuarela y Tinta China sobre papel	18.50	27.00	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
208	4601	Salsa	Acuarela y Tinta China sobre papel	21.00	29.50	2010	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
209	5449	No me presta la atención	Acuarela y Tinta China sobre papel	26.50	21.00	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
210	5445	Falta poco	Acuarela y Tinta China sobre papel	20.00	26.50	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
211	5381	amigos para siempre	Acuarela y Tinta China sobre papel	20.50	29.50	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
212	5258	Mamita si es grande	Acuarela y Tinta China sobre papel	21.00	29.50	2012	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
213	5260	sentado sobre el incierto	Acuarela y Tinta China sobre papel	21.00	29.50	2012	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
214	5271	Yo puedo hacer algo que mi papi no puede	Acuarela y Tinta China sobre papel	21.00	29.50	2012	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
215	5375	Puj-ja	Acuarela y Tinta China sobre papel	27.00	37.00	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
216	5257	irán para el cielo	Acuarela y Tinta China sobre papel	32.00	22.50	2012	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
217	5379	niños bailando la raspa	Acuarela y Tinta China sobre papel	27.00	37.00	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
218	4602	nuestro mundo sin horizontes	Acuarela y Tinta China sobre papel	21.00	29.50	2010	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
219	5450	qué fastidio con estos muchachos	Acuarela y Tinta China sobre papel	27.00	32.50	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
220	5380	temprana incorporación a la disciplina	Acuarela y Tinta China sobre papel	27.00	37.00	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
221	5389	… Y ya viene el otro	Acuarela y Tinta China sobre papel	26.50	37.00	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
222	5259	ya escucho a mi hermanito	Acuarela y Tinta China sobre papel	21.00	29.50	2012	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
223	5448	Tienes sueño	Acuarela y Tinta China sobre papel	16.00	26.50	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
224	5447	mamitis	Acuarela y Tinta China sobre papel	20.00	29.50	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
225	5434	mamita para todo	Acuarela y Tinta China sobre papel	26.50	37.00	2013	\N	base en acuarela y dibujo en tinta china	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
226	4828	La luna y el sol	Acuarela y grafito sobre papel	21.00	28.50	2010	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
227	4847	eco congresantes	Acuarela, Creyón y Tinta China sobre papel	21.00	28.00	2010	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
228	2233	El Hombre de la  mar Con sus protagonistas	Acuarela y Tinta China sobre papel	39.50	30.00	2000	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
229	4912	Vida marina	Acuarela y Tinta China sobre papel	32.00	45.00	2010	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
230	5044	El re calentamiento global	Acuarela y Tinta China sobre papel	47.00	22.50	2011	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
231	3933	Por qué	Acuarela sobre papel	47.00	32.00	2007	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
232	5011	Ahí viene el monstruo de dos patas a matarnos	Acuarela y Tinta China sobre papel	33.00	47.00	2011	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
233	2080	El hombre de la mar si cuida los corales	Grafito sobre papel	39.50	28.50	1999	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
234	4827	La eco conservación	Acuarela y Tinta China sobre papel	32.00	44.00	2010	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
235	5006	Re calentamiento global	Acuarela y Tinta China sobre papel	24.00	33.00	2011	Medio ambiente y ecología	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
236	5035	Pajarracos	Acuarela sobre papel	21.50	28.00	2011	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
237	5053	El empate	Acuarela sobre papel	20.50	28.50	2011	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
238	4934	Mi pareja	Acuarela sobre papel	22.00	28.00	2011	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
239	2804	pájaros al atardecer	Acuarela sobre papel	29.00	21.00	2004	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
240	4720	El pajarraco me trajo una hermanita	Acuarela sobre papel	21.50	28.00	2010	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
241	5876	Pelícanos	tinta china sobre papel	42.00	29.50	2016	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
242	5877	Pajarracos	tinta china sobre papel	42.00	29.50	2016	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
243	5888	El almuerzo	tinta china sobre papel	19.50	25.50	2016	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
244	5895	Tiranerias	Acuarela y Tinta China sobre papel	28.00	34.00	2016	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
245	3541	El pajarraco está pendiente	Acuarela y Tinta China sobre papel	37.50	27.00	2006	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
246	4447	El almuerzo	tinta china sobre papel	28.00	21.50	2009	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
247	3417	la leyenda de pajarraco	\N	27.00	23.00	2016	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
248	2796	Pajarracos	Acuarela sobre papel	32.00	22.00	2004	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
249	3526	Apunte Pelícano	Acuarela y Tinta China sobre papel	21.50	28.00	2006	Apuntes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
250	4890	Composición tiranera	Acuarela sobre papel	42.00	32.50	2010	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
251	4947	Escenas del guayamuri	Acuarela sobre papel	45.00	30.00	2010	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
252	3488	Pajarraco	Acuarela y Tinta China sobre papel	16.00	22.00	2006	Pájaros de mar	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
253	4254	Escudo de Ayuntamiento de nueva Cádiz	Oil Pastel sobre papel	5.00	43.50	2008	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
254	593	Indio de Perijá adentro	Acuarela sobre papel	28.00	38.50	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
255	3065	la laguna de la Restinga guaiqueríes	Acuarela y Tinta China sobre papel	23.00	28.50	2005	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
256	4520	Miss Guaicora	Acuarela sobre papel	14.00	31.50	2009	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
257	4956	Papá indio	Acuarela y Tinta China sobre papel	23.50	32.00	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
258	4811	concentración	Acuarela y Tinta China sobre papel	21.00	28.50	2010	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
259	4115	la guaicora	Acuarela y Tinta China sobre papel	23.50	32.00	2008	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
260	3281	La india	Acuarela y Tinta China sobre papel	20.50	34.00	2005	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
261	5864	Guayamuri	tinta china sobre papel	30.00	42.00	2016	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
262	5859	En 1948 ???	tinta china sobre papel	30.00	42.00	2016	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
263	5868	El indio Guaiquerí visto por Alejandro Colina	tinta china sobre papel	30.00	21.50	2016	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
264	5021	India piaroa	tinta china sobre papel	28.00	36.50	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
265	2820	Acuareleando una Guaicora	Acuarela sobre papel	35.50	51.00	2005	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
266	4950	Indio Guaiquerí	Acuarela y Tinta China sobre papel	23.50	32.00	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
267	4953	El indio Guaiquerí	Acuarela y Tinta China sobre papel	23.50	32.00	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
268	4488	El empate de guayamuri	Acuarela sobre papel	41.00	30.00	2009	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
269	4554	Las dos manos de la india	tinta china sobre papel	32.00	47.00	2009	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
270	4247	la India Guaiquerí	Oil Pastel sobre papel	32.00	44.00	2008	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
271	4393	Cerámica indígena	Acuarela sobre papel	32.00	44.00	2009	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
272	5022	India Yukpa Perija	Acuarela y Tinta China sobre papel	28.00	40.00	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
273	5024	India Guahibo por Manapiare	Acuarela y Tinta China sobre papel	28.50	38.50	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
274	4482	La luna cupido	Acuarela y Tinta China sobre papel	41.00	29.50	2009	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
275	5020	India panare	Acuarela y Tinta China sobre papel	28.00	37.00	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
276	4938	India morena complete crineja postiza	Acuarela y Tinta China sobre papel	29.50	39.00	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
277	4387	Al indiecito le salió baño	Acuarela y Tinta China sobre papel	32.00	45.00	2009	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
278	5025	India Arauca Adentro	Acuarela y Tinta China sobre papel	38.00	28.00	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
279	4503	Madre indígena	Acuarela y Tinta China sobre papel	23.50	32.00	2009	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
280	4775	Indio embarcado	Acuarela y Tinta China sobre papel	27.00	37.00	2010	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
281	5019	La india con su bebé	tinta china sobre papel	28.50	38.50	2011	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
282	1348	Año 1348 en paraguaChoa	tinta china sobre papel	22.50	30.50	1996	Indígenas e indios Guaiqueríes	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
283	5837	Chacachacare	Acuarela sobre papel	17.50	14.00	2006	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
284	??	Macanao	Grafito y creyón sobre papel	21.00	30.00	2010	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
285	3072	Caña de azúcar	Grafito sobre papel	18.00	28.00	2005	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
286	1985	El Portachuelo la otra banda en 1985 número 1978	Grafito sobre papel	30.50	23.50	1999	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
287	1970	Playa parejito 1970 número 1856	Acuarela sobre papel	30.50	20.50	1999	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
288	1836	Boca chica	Acuarela sobre papel	35.50	25.00	1999	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
289	1968	Apunto de 1968 Playa puerto Cruz técnica grafito y Creyón sobre papel dimensión 30.5 por 21.5 cm año 2014	Grafito y creyón sobre papel	30.50	21.50	2014	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
290	3640	Laguna de las Maritza número 3640 técnica Quellón sobre papel dimensión 34 × 25 cm año 2006	Creyón sobre papel	34.00	25.00	2006	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
291	915	Cocos número 915 técnica grafito acuarela sobre papel dimensión 34 × 24 cm año 1992	Grafito y acuarela sobre papel	34.00	24.00	1992	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
292	3555	naturaleza número 35 55 técnica grafito con acuarela sobre papel dimensión 24 × 33 cm año 2006	Grafito y acuarela sobre papel	24.00	33.00	2006	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
293	4948	Olas en la roca	Acuarela sobre papel	23.50	32.00	2011	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
294	5078	Guayamuri desde la alcaldía 5078 técnica grafito sobre papel dimensión 30.5 × 21.5 cm año 2011	Grafito sobre papel	30.50	21.50	2011	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
295	3659	En la laguna de la Restinga número 3659 técnica grafito Quellón sobre papel dimensión 20 y 1 cm por 29.5 cm año 2006	Grafito y creyón sobre papel	20.10	29.50	2006	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
296	1798	El Guamache, isla de coche número 1798 técnica grafito con acuarela dimensión 35.5 × 25 cm año 1999	Grafito y acuarela sobre papel	35.50	25.00	1999	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
297	1979	Boca chica macanada número 1979 técnica grafito acuarela sobre papel dimensión 35.5 × 27.5 cm año 1999	Grafito y acuarela sobre papel	35.50	27.50	1999	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
298	4867	Pitigüey	Acuarela sobre papel	30.00	44.50	2010	Naturaleza Isla de Margarita	costumbrista	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
299	1975	El cogollo tema de 1975 número 4566 técnica tinta sobre papel dimensión 29.5 × 31 cm año 2010	tinta china sobre papel	29.50	31.00	\N	Naturaleza Isla de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
300	4163	Corazón de madre número 4163 técnica grafito y agua sobre papel dimensión 23.5 × 32 cm año 2008	Grafito y acuarela sobre papel	23.50	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
301	4929	Todavía no se me nota número 4929 técnica tinta china y aguada sobre papel dimensión 21.5 × 28 cm año 2011	Acuarela y Tinta China sobre papel	23.50	28.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
302	2946	Si nombre Madre número 2946 técnica grafito sobre papel dimensión 28.5 × 20 cm año 2004	Grafito sobre papel	28.50	20.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
303	4772	Mami mamita número 4772 técnica tinta y agua sobre papel dimensión 29.5 × 41 cm año 2010	Acuarela y Tinta China sobre papel	29.50	41.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
304	4909	Cariño y amor número 4909 técnica tinta y aguada sobre papel dimensión 32 × 45 cm año 2010	Acuarela y Tinta China sobre papel	32.00	45.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
305	4706	Maternidad número 4706 técnica aguada de base y dibujo en tinta china sobre papel dimensión 32 cm por 39.5 cm año 2010	base acuarela y dibujo tinta china	32.00	39.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
306	3266	Be be So número 3266 técnica tinta china y aguada dimensión 24 × 33 cm año 2005 obra con firma de Carlos en japonés	Acuarela y Tinta China sobre papel	24.00	33.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
307	4494	Es mi bebé número 4494 técnica tinta sobre papel dimensión 27 × 37 cm año 2009	tinta china sobre papel	27.00	37.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
308	4502	El deseo de ser madre número 4502 técnica tinta y agua sobre papel dimensión 32 × 45 cm año 2009	Acuarela y Tinta China sobre papel	32.00	45.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
309	3779	Enamorada número 3779 técnica agua sobre papel dimensión 23.5 x 32 cm año 2007	Acuarela y Tinta China sobre papel	23.50	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
310	4433	Yaya número 4433 técnica acuarela sobre papel dimensión 21 × 28.5 cm año 2009	Acuarela sobre papel	21.00	28.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
311	3775	Penosa número 3775 técnica tinta china y aguada sobre papel dimensión 23.5 × 30 cm año 2007	Acuarela y Tinta China sobre papel	23.50	30.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
312	4731	Cuál será mi futuro número 4731 técnica Finca y agua sobre papel dimensión 30 × 45 cm año 2010	Acuarela y Tinta China sobre papel	30.00	45.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
313	3782	La trigueña número 3782 técnica tinta y aguada sobre papel dimensión 39 × 29 cm año 2007	Acuarela y Tinta China sobre papel	39.00	29.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
314	4126	Unos kilitos demás número 4126 técnica tinta y acuarela sobre papel dimensión 32 × 43.5 cm año 2008	Acuarela y Tinta China sobre papel	32.00	43.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
315	3700	La maja del pico Naiguatá número 3700 técnica pinta y aguada sobre papel dimensión 30 × 23 cm año 2007	Acuarela y Tinta China sobre papel	30.00	23.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
316	4686	Mantener la línea número 4686 técnica agua sobre papel dimensión 21.5 × 28 cm año 2010	Acuarela sobre papel	21.50	28.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
317	4435	En la línea número 4435 técnica finca y aguada sobre papel dimensión 27 × 34.5 cm año 2009	Acuarela y Tinta China sobre papel	27.00	34.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
318	4739	El sueño de muchas número 4739 técnica tinta china y aguada sobre papel dimensión 23 × 32 cm año 2010	Acuarela y Tinta China sobre papel	23.00	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
319	4771	Trabaja para su hija número 4771 técnica tinta y aguada sobre papel dimensión 23.5 × 32 cm año 2010	Acuarela y Tinta China sobre papel	23.50	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
320	4803	La dama mayor número 4803 técnica grafito y aguada sobre papel dimensión 25 × 32 cm año 2010	Grafito y acuarela sobre papel	25.00	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
321	5824	Tema de una conversa número 5824 técnica tinta china sobre papel dimensión 30 × 21.5 cm año 2016	tinta china sobre papel	30.00	21.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
322	2718	Modelo sirena número 2718 técnica grafito y aguada sobre papel dimensión 21 × 30 cm año 2003	Grafito y acuarela sobre papel	21.00	30.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
323	3090	La arepa número 3090 técnica aguada dimensión 27 × 36 cm año 2005	Acuarela sobre papel	27.00	36.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
324	4181	La maja del guaya Muri número 4181 técnica agua sobre papel dimensión 23 × 32 cm año 2008	Acuarela sobre papel	23.00	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
325	4752	Mamita cómprame un celular número 4752 técnica tinta china con agua sobre papel dimensión 32 × 45 cm año 2010	Acuarela y Tinta China sobre papel	32.00	45.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
326	4484	Las mujeres se pusieron a valer número 4484 técnica tinta china y aguada sobre papel dimensión 30 × 41 cm año 2009	Acuarela y Tinta China sobre papel	30.00	41.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
327	4009	Dibujo de modelos en Caracas número 4009 técnica tinta Y aguada sobre papel dimensión 33 × 48 cm año 2007	Acuarela y Tinta China sobre papel	33.00	48.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
328	4010	Modelo desnudo Caracas número 4010 técnica tinta y agua sobre papel dimensión 33 × 48 cm año 2007 (dibujo doble en el mismo papel)	Acuarela y Tinta China sobre papel	33.00	48.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
329	3775	Penosa número 3775 a técnica tinta y aguada sobre papel dimensión 30 × 42 cm año 2007	Acuarela y Tinta China sobre papel	30.00	42.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
330	5048	La sirena número 5048 técnica aguada y tinta sobre papel dimensión 32 × 45 cm año 2010	Acuarela y Tinta China sobre papel	32.00	45.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
331	4329	Yamaha sirena número 4329 técnicas tinta china y aguada sobre papel dimensión 34.5 × 28 cm año 2008	Acuarela y Tinta China sobre papel	34.50	28.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
332	21	Apunte sin nombre sin número técnica marcador dimensión 21.5 × 35 cm año 2006	Marcador sobre papel	21.50	35.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
333	4773	la ñera pura número 4773 técnica tinta y aguada sobre papel dimensión 27 por 37 cm año 2010	Acuarela y Tinta China sobre papel	27.00	37.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
334	4287	Mujer con un pargo número 4287 técnica pinta y aguada sobre papel dimensión 23.5 × 32 cm año 2009	Acuarela y Tinta China sobre papel	23.50	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
335	4740	Metamorfosis en camino número 4740 técnica pinta y aguada sobre papel dimensión 32 × 45 cm año 2010	Acuarela y Tinta China sobre papel	32.00	45.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
336	4507	El encanto de una sirena número 4507 técnicas tinta sobre papel dimensión 41 × 30 cm año 2009	tinta china sobre papel	41.00	30.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
337	4184	La Maja del Tamoco y la que cuida Arimacoa número 4184 técnica tinta sobre papel dimensión 47 × 32 cm año 2008	tinta china sobre papel	47.00	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
338	4776	Cancán de sirenas número 4776 técnica tinta china y acuarela sobre papel dimensión 44.5 × 32 cm año 2010	Acuarela y Tinta China sobre papel	44.50	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
339	3278	La conversa playera número 3278 técnica Finca China y acuarela sobre papel dimensión 45.5 × 30.5 cm año 2005	Acuarela y Tinta China sobre papel	45.50	30.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
340	4770	Ñera Pura Número 4770 técnica China y acuarela sobre papel dimensión 32 × 44.5 cm año 2010	Acuarela y Tinta China sobre papel	32.00	44.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
341	4453	La negra número 4453 técnica pinta con acuarela sobre papel dimensión 28 × 34.5 cm año 2009	Acuarela y Tinta China sobre papel	28.00	34.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
342	4841	Etnia Diferente número 4841 técnica tinta china y aguada sobre papel dimensión 32 × 40.4 cm año 2010	Acuarela y Tinta China sobre papel	32.00	40.40	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
343	4183	La maja del mata siete y la del guaya Muri número 4183 técnica acuarela sobre papel dimensión 46 × 32 cm año 2008	Acuarela sobre papel	46.00	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
344	4188	La maja de la galera número 4188 técnica acuarela sobre papel dimensión 46 × 32 cm año 2008	Acuarela sobre papel	46.00	32.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
345	4186	La maja de la guardia	Acuarela sobre papel	45.00	32.00	2008	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
346	4895	modelo un minuto 4895 técnica grafito y acuarela sobre papel dimensión 30 × 40.5 cm año 2010	Grafito y acuarela sobre papel	30.00	40.50	2010	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
347	5004	Hoy no hay escuela. Número 5004 técnica acuarela y tinta china sobre papel di mención 21.5 × 28 cm años 2011	Acuarela y Tinta China sobre papel	21.50	28.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
348	4812	Bodypaint la gata mujer número 4812 técnica tinta china y aguada sobre papel dimensión 21 × 28.5 cm año 2010	Acuarela y Tinta China sobre papel	21.00	28.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
349	2707	Modelo número 2707 técnica grafito y acuarela sobre papel dimensión 35 × 28 cm año 2003	Grafito y acuarela sobre papel	28.00	35.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
350	2699	Modelo con niña asombrada número 2699 técnica acuarela y grafito sobre papel dimensión 28 × 35 cm año 2003	Grafito y acuarela sobre papel	28.00	35.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
351	5451	La mata mujer número 5451 técnica tinta y acuarela sobre papel dimensión 27 × 33 cm año 2003	Acuarela y Tinta China sobre papel	27.00	33.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
352	4440	La mata mujer en el sueño número 4440 técnica acuarela sobre papel dimensión 28 × 34.5 cm año 2009	Acuarela sobre papel	28.00	34.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
353	2835	Modelo número 2835 técnica tinta y acuarela sobre papel dimensión 26.5 × 37.5 cm año 2003	Acuarela y Tinta China sobre papel	26.50	37.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
354	4212	La sirena número 4212 técnica oil pastel sobre papel dimensión 32 × 47 cm año 2008	Oil Pastel sobre papel	32.00	47.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
355	1569	Ladys Godiva en Europa continental número 1569 técnica tinta china y acuarelas sobre papel de topografía dimensión 28 × 35.5 año 1997	Acuarela y Tinta China sobre papel	28.00	35.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
356	3416	Dolor de cabeza número 3416 técnica tinta china y acuarela sobre papel dimensión 27 × 37.5 cm año 2006	Acuarela y Tinta China sobre papel	27.00	37.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
357	4617	Modelo número 4617 técnica el bracito sobre papel dimensión 30 por 42 cm año 2005	\N	30.00	42.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
358	2776	Signo hombre retrato número 2776 técnica tinta y acuarela sobre papel dimensión 26.5 × 37 cm año 2003	Acuarela y Tinta China sobre papel	26.50	37.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
359	3780	Modelo y dibujantes en ejercicio Número 3780 técnica tinta china y acuarela sobre papel dimensión 38.5 × 29 cm año 2007	Acuarela y Tinta China sobre papel	38.50	29.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
360	3786	La rubia y la morena número 3786 técnica tinta china y acuarela sobre papel dimensión 30 × 42 cm año 2007	Acuarela y Tinta China sobre papel	30.00	42.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
361	4609	La propia número 4609 técnica tinta sobre papel dimensión 21 × 30.5 cm año 2009	tinta china sobre papel	21.00	30.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
362	3407	La Marilyn adorada número 3407 técnica tinta china acuarela sobre papel dimensión 30 × 46 cm año 2006	Acuarela y Tinta China sobre papel	30.00	46.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
363	3409	El beso imaginario número 3409 técnica tinta china y aguada sobre papel dimensión 36 × 30 cm año 2006	Acuarela y Tinta China sobre papel	36.00	30.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
364	4606	La bendición me voy número 4606 técnica tinta china y acuarela sobre papel dimensión 21 × 29.5 año 2010	Acuarela y Tinta China sobre papel	21.00	29.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
365	3771	Mi abuelita vive en su Caney número 3771 técnica pinta y aguada sobre papel dimensión 23.5 × 32.5 cm	Acuarela y Tinta China sobre papel	23.50	32.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
366	4732	Son bellas parecen reinas número 4732 técnica pinta sobre papel dimensión 21 28.5 cm año 2010	Acuarela sobre papel	21.00	28.50	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
367	2702	Modelos en la Isla de Pascua número 2702 técnica grafito y acuarela sobre papel dimensión 35 × 24 cm año 2003	Grafito y acuarela sobre papel	35.00	24.00	\N	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
368	5552	Recordando a Fermina	Acuarela y Tinta China sobre papel	\N	\N	2014	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
369	5546	Mis sirenas número	Acuarela y Tinta China sobre papel	\N	\N	2014	mujeres y maternidad	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
370	4499	Bajo la luna número 4499 técnica tinta china y agua sobre papel dimensión 19 × 23.5 cm año 2009	Acuarela y Tinta China sobre papel	19.00	23.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
371	3404	La pareja moderna 3404 técnica aguada y grafito sobre papel dimensión 21 × 30 cm año 2006	Grafito y acuarela sobre papel	21.00	30.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
372	3864	Enamorado número 3864 técnica tinta y acuarela sobre papel dimensión 23.5 × 32 cm año 2007	Acuarela y Tinta China sobre papel	23.50	32.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
373	3897	No sólo de pan vive el cuerpo número 3897 técnica tinta china dimensión 20 × 25 cm año 2007	tinta china sobre papel	20.00	25.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
374	5026	Pares o nones número 5026 técnica tinta china y acuarela sobre papel dimensión 21.5 × 28 cm año 2011	\N	21.50	28.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
375	1930	Año 1930 copete gallo y Bubikopf número 5012 técnica tinta china y acuarela sobre papel dimensión 33 × 46 cm año 2011	Acuarela y Tinta China sobre papel	33.00	46.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
376	3285	Cariño real número 3285 técnica tinta china y acuarela sobre papel topográfico dimensión 22 por 28.5 cm año 2005	Acuarela y Tinta China sobre papel	22.00	28.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
377	3724	El beso número 3724 técnica tinta y acuarela sobre papel dimensión 26.5 × 35.5 cm año 2007	Acuarela y Tinta China sobre papel	26.50	35.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
378	3705	Amor eterno número 3705 técnica grafito sobre papel dimensión 27 × 35.5 cm año 2007	Grafito sobre papel	27.00	35.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
379	3406	Sueño con… Número 3406 técnica tinta y acuarela sobre papel dimensión 29.5 × 36 cm año 2006	Acuarela y Tinta China sobre papel	29.50	36.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
380	4857	Árbol genealógico número 4857 técnica tinta china y acuarela sobre papel dimensión 23.5 × 32 cm año 2010	Acuarela y Tinta China sobre papel	23.50	32.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
381	3871	Todos los animales ama número 3871 técnica tinta y acuarela sobre papel dimensión 29.5 × 42 cm año 2007	Acuarela y Tinta China sobre papel	29.50	42.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
382	3405	El beso apunte número 3405 técnica tinta y acuarela sobre papel dimensión 27 × 33 cm año 2006	Acuarela y Tinta China sobre papel	27.00	33.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
383	4823	Cita a ciegas número 4823 técnica tinta china acuarela sobre papel dimensión 32 cm por 44 cm año 2010	Acuarela y Tinta China sobre papel	32.00	44.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
384	3291	Besos ceremonial número 3291 técnica tinta china y acuarela sobre papel topográfico dimensión 35.5 × 28 cm año 2005	Acuarela y Tinta China sobre papel	35.50	28.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
385	4894	Preferencias número 4894 técnica tinta china y agua sobre papel dimensión 32 × 45 cm año 2010	Acuarela y Tinta China sobre papel	32.00	45.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
386	4778	Fidelidad número 4778 técnica tinta china grafito y acuarela sobre papel dimensión 27 × 37 cm año 2010	tinta china y Grafito sobre papel	27.00	37.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
387	4852	Bodas de oro número 4852 técnica tinta y acuarela sobre papel dimensión 27 × 37 cm año 2010	Acuarela y Tinta China sobre papel	27.00	37.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
388	4478	El amante número 4478 técnica tinta china y acuarela sobre papel dimensión 32 × 45 cm año 2009	Acuarela y Tinta China sobre papel	32.00	45.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
389	3289	Beso sorpresivo número 3289 técnica tinta china y aguada sobre papel topográfico dimensión 24 × 25.5 cm año 2005	Acuarela y Tinta China sobre papel	24.00	25.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
390	3280	El pasado grato número 3280 técnica acuarela sobre papel dimensión 21 × 29.5 cm año 2005	Acuarela sobre papel	21.00	29.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
391	3846	Original de la parte central de 3846 número 3845 a técnica tinta sobre papel dimensión 27 × 18 cm año 2011	tinta china sobre papel	27.00	18.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
392	1562	El beso técnica finca sobre papel de un plano con curvas de nivel número 1562 dimensión 25 × 35 cm año 1997	tinta china sobre papel	25.00	35.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
393	4425	El sueño con galanes número 4425 técnica tinta sobre papel dimensión 23.5 × 32 cm sin firma sin año	tinta china sobre papel	23.50	32.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
394	3852	Sin nombre el beso número 3852 técnica sobre papel dimensión 24.5 × 32.5 cm año 2007	tinta china sobre papel	24.50	32.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
395	3722	El beso número 3722 técnica tinta y agua sobre papel dimensión 26.5 × 35.5 cm año 2007	Acuarela y Tinta China sobre papel	26.50	35.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
396	3405	Las paredes número 3405 técnica tinta y acuarela sobre papel dimensión 29.5 × 42 cm año 2006	Acuarela y Tinta China sobre papel	29.50	42.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
397	3401	Nuestro amor comenzó sin importancia número 3401 técnica cinta y acuarela sobre papel dimensión 29.5 × 42.5 cm año 2006	Acuarela y Tinta China sobre papel	29.50	42.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
398	3411	Aponte número 3411 técnica tinta y acuarela sobre papel dimensión 27 x 41 cm año 2006	Acuarela y Tinta China sobre papel	27.00	41.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
399	3403	A a a y … Número 3403 técnica grafito y acuarela sobre papel dimensión 42 × 30 cm año 2006	Grafito y acuarela sobre papel	42.00	30.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
400	4751	Tentación número 4751 técnica tinta china y acuarela sobre papel dimensión 32 × 45.5 cm año 2010	Acuarela y Tinta China sobre papel	32.00	45.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.716305	2026-10-13 01:32:13.716305
401	3784	Ada nieva número 3784 técnica tinta china y aguada sobre papel dimensión 30 × 42 cm año 2007	Acuarela y Tinta China sobre papel	30.00	42.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
402	3781	Caricias número 3781 técnica tinta china y agua sobre papel dimensión 30 × 37 cm año 2007	Acuarela y Tinta China sobre papel	30.00	37.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
403	4417	La pelo lindo espera casarse número 4417 técnica tinta china y acuarela sobre papel número 28 × 44.5 cm año 2009	Acuarela y Tinta China sobre papel	28.00	44.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
404	3225	Sin nombre pareja número 3225 técnica tinta china y agua sobre papel dimensión 47.5 × 33.5 cm año 2005	Acuarela y Tinta China sobre papel	47.50	33.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
405	4487	Sueño raro número 4487 técnica tinta china y acuarela sobre papel dimensión 29.5 × 41 cm año 2009	Acuarela y Tinta China sobre papel	29.50	41.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
406	3851	Sin nombre parejas número 3851 técnica tinta sobre papel dimensión 25 × 33.5 cm año 2007	tinta china sobre papel	25.00	33.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
407	5003	No me manosees número 5003 técnica tinta china y aguada sobre papel dimensión 29 × 40 cm año 2011	Acuarela y Tinta China sobre papel	29.00	40.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
408	4705	El primer número 4705 técnica tinta y aguada sobre papel dimensión 27 × 37 cm año 2010	Acuarela y Tinta China sobre papel	27.00	37.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
409	4713	El viejo verde número 4713 técnica pinta y agua sobre papel dimensión 27 × 37 cm año 2010	Acuarela y Tinta China sobre papel	27.00	37.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
410	4808	Bodypaint Exótico número 4808 técnica tinta china y acuarela sobre papel dimensión 27 × 37 cm año 2010	Acuarela y Tinta China sobre papel	27.00	37.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
411	4219	Bailarines número 4219 técnica oil pastel dimensión 32 × 46 cm año 2008	Oil Pastel sobre papel	32.00	46.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
412	4431	El ancla de la discreción número 4431 técnica tinta china y acuarela sobre papel dimensión 41 × 30 cm año 2009	Acuarela y Tinta China sobre papel	41.00	30.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
413	4779	Los deberes se comparten Número 4779 técnica tinta china y acuarela sobre papel dimensión 32 × 23 cm año 2010	Acuarela y Tinta China sobre papel	32.00	23.00	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
414	3723	El beso número 3723 técnica tinta china y acuarela sobre papel dimensión 26 × 35.5 cm año 2007	Acuarela y Tinta China sobre papel	26.00	35.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
415	5001	Bailar un bolero sobre el cuadrito es como estar en el séptimo cielo número 5001 técnica tinta china y agua sobre papel di mención 29.5 × 40.5 cm	Acuarela y Tinta China sobre papel	29.50	40.50	\N	parejas, amor y sexo	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
416	4904	Mosca con los demás número 4904 técnica tinta china y aguada sobre papel dimensión 32 × 45.5 cm año 2010	Acuarela y Tinta China sobre papel	32.00	45.50	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
417	4220	La dulce espera número 4220 técnica oil pastel dimensión 32 × 47 cm año 2008	Oil Pastel sobre papel	32.00	47.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
418	4842	No acariciar hable número 4842 técnica tinta china y acuarela sobre papel di mención 28 × 21 cm año 2010	Acuarela y Tinta China sobre papel	28.00	21.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
419	4724	Sabroso número 4724 técnica acuarela sobre papel di mención 24.5 × 33.5 cm año 2010	Acuarela sobre papel	24.50	33.50	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
420	4164	La dulce espera número 4164 técnica tinta china y acuarela sobre papel di mención 23.5 × 32 cm año 2008	Acuarela y Tinta China sobre papel	23.50	23.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
421	4218	El Yin-yan número 4218 técnica oiL pastel dimensión 23.5 × 32 cm cine año sin firma	Oil Pastel sobre papel	23.50	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
422	4236	Hijo de gato caza de ratones número 4236 técnica grafito sobre papel di mención 21 × 28.5 cm año 2008	Grafito sobre papel	21.00	21.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
423	4933	Trabajador público número 4933 técnica pinta y acuarela sobre papel dimensión 21.5 × 30.5 cm año 2011	Acuarela y Tinta China sobre papel	21.50	5.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
424	4681	La meditación purifica número 4681 técnica tinta china y acuarelas sobre papel di mención 22.5 × 30 cm año 2010	Acuarela y Tinta China sobre papel	22.50	22.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
425	4608	El deseo número 4608 técnica tinta china y acuarela sobre papel di mención 21 × 30 cm. Año 2010	Acuarela y Tinta China sobre papel	21.00	21.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
426	4493	Unión en cuerpo y alma número 4493 técnica tinta sobre papel di mención 20.5 × 30 cm año 2009	tinta china sobre papel	20.50	20.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
427	4348	GeGo era única número 4348 técnica pinta sobre papel di mención 22 × 32 cm año 2009	tinta china sobre papel	22.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
428	4971	Adorno tira Nero número 4971 técnica tinta y acuarela sobre papel di mención 32 × 23.5 cm año 2011	Acuarela y Tinta China sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
429	4506	Nos hemos olvidado de las buenas costumbres número 4506 técnica tinta y agua sobre papel di mención 20.5 × 30 cm año 2009	Acuarela y Tinta China sobre papel	20.50	20.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
430	4716	Invento checo número 4716 técnica pinta y acuarela sobre papel di mención 22 × 28 cm año 2010	Acuarela y Tinta China sobre papel	22.00	22.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
431	4723	El parejo feliz número 4723 técnica acuarela y tinta china sobre papel di mención 21 × 29.5 cm año 2010	Acuarela y Tinta China sobre papel	21.00	21.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
432	5726	Ay Darwin número 5726 técnica acuarela y tinta china di mención 21. 5 × 28 cm año 2010	Acuarela y Tinta China sobre papel	5.00	5.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
433	5841	Trabajando juntos número 5841 técnica tinta y acuarela sobre papel di mención 22 × 25.5 cm año 2016	Acuarela y Tinta China sobre papel	22.00	22.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
434	5834	Admirable número 5834 técnica pinta de China di mención 21.5 × 30.5 año 2016	tinta china sobre papel	21.50	5.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
435	5830	La mano que creó el mundo número 5830 técnica tinta china sobre papel di mención 30.5 × 21.5 cm año 2016	tinta china sobre papel	30.50	30.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
436	5833	El hombre araña número 5833 técnica tinta china sobre papel di mención 30.5 × 21.5 cm año 2016	Acuarela y Tinta China sobre papel	30.50	30.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
437	4449	Mal de amores número 4449 técnica acuarela di mención 23.5 × 32 cm año 2011	Acuarela y Tinta China sobre papel	23.50	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
438	4945	Dos corazones en uno número 4945 técnica tinta y acuarela sobre papel di mención 21 × 29.5 cm año 2010	Acuarela y Tinta China sobre papel	21.00	21.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
439	5052	El mundo de la sirena número 5052 técnica tinta china con acuarelas sobre papel di mención 28 × 39 cm año 2011	Acuarela y Tinta China sobre papel	28.00	39.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
440	5007	Plantilla para descifrar un código secreto número 5007 técnica pinta y acuarela sobre papel di mención 32.5 × 24 cm año 2011	Acuarela y Tinta China sobre papel	32.50	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
441	3718	Los amantes número 3718 técnica tinta china y acuarela sobre papel di mención 26 8.5 × 21 cm año 2006	Acuarela y Tinta China sobre papel	8.50	26.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
442	4957	El empate número 4957 técnica acuarela sobre papel di mención 23.5 × 32 cm año 2011	Acuarela sobre papel	23.50	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
443	4242	Los jóvenes no conocen límites número 4242 técnica oil pastel di mención 32 × 47 cm año 2008	Oil Pastel sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
444	4824	Fémina número 4824 técnica tinta china y acuarela sobre papel di mención 32 × 45 cm año 2010	Acuarela y Tinta China sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
445	5014	Locaina moderna número 5014 técnica tinta y acuarela sobre papel di mención 32.5 × 46 cm ancho 2011	Acuarela y Tinta China sobre papel	32.50	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
446	4803	El sol enamorado de la luna número 4803 técnica tinta y acuarela sobre papel di mención 30 × 44 cm año 2010	Acuarela y Tinta China sobre papel	30.00	44.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
447	4240	La sonrisa y la naturaleza número 4240 técnica oil pastel di mención 32 × 47 cm año 2008	Oil Pastel sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
448	4810	Eran de esmalte número 4810 técnica tinta y acuarela sobre papel di mención 37 × 27 cm año 2010	Acuarela y Tinta China sobre papel	37.00	37.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
449	4898	Había en mi vida un gran amor número 4898 técnica pinta y acuarela sobre papel y mención 32 × 45.5 cm año 2010	Acuarela y Tinta China sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
450	4210	El andino número 4210 técnica o il pastel di mención 32 × 47 cm año 2008	Oil Pastel sobre papel	32.00	47.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
451	4907	Ojo que ve corazón que siente número 4907 técnica acuarela y tinta china sobre papel dimensión 32 × 45 cm año 2010	Acuarela y Tinta China sobre papel	32.00	45.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
452	4211	El milatico (no se entiende el nombre de la obra) Número 4211 técnica oil pastel dimensión 32 × 47 cm año 2008	Oil Pastel sobre papel	32.00	47.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
453	4889	El vende pan número 4889 técnica tinta y acuarela sobre papel dimensión 27 × 37 cm año 2010	Acuarela y Tinta China sobre papel	27.00	27.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
454	4918	Disparate en órbita está la eclipse elíptica número 4918 técnica pinta sobre papel dimensión 32 × 44.5 cm	Acuarela sobre papel	32.00	44.50	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
455	4449	El mundo sin rumbo número 4449 técnica tinta y agua sobre papel dimensión 28 × 30.5 cm año 2009	Acuarela y Tinta China sobre papel	28.00	28.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
456	5049	La conversa con la hija número 5049 técnica tinta china sobre papel dimensión 33 × 44 cm año 2011	Tinta China sobre papel	33.00	33.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
457	4815	Hay química número 4815 técnica tinta china y aguada sobre papel dimensión 27 × 37 cm año 2010	Acuarela y Tinta China sobre papel	27.00	27.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
458	32	Vuelo supersónico comercial técnica tinta y agua sobre papel di mención 32 × 44.5 año 2010	Acuarela y Tinta China sobre papel	44.00	44.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
459	4930	Fémina soltera número 4930 técnica tinta y agua sobre papel di mención 32 × 45.5 cm año 2011	Acuarela y Tinta China sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
460	4826	Campo mágico del amor número 4826 técnica tinta y agua sobre papel dimensión 32 × 44.5 cm año 2010	Acuarela y Tinta China sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
461	4262	La envidiada número 4262 técnica oil pastel dimensión 32 × 47 cm año 2008	Oil Pastel sobre papel	32.00	47.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
462	4152	Amor eterno número 4152 Técnica tinta y agua sobre papel di mención 32 × 46 cm año 2008	Acuarela y Tinta China sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
463	802	Signo hombre número 802 técnica tinta china sobre papel di mención 30.5 × 24 cm año 1991	Tinta China sobre papel	30.50	5.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
464	4869	Ojo pelado número 4869 técnica pinta y acuarela sobre papel di mención 32 × 44.5 cm año 2010	Acuarela y Tinta China sobre papel	32.00	32.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
465	4862	Windsurf 4862 técnica tinta china y acuarela sobre papel di mención 32 × 44 cm año 2010	Acuarela y Tinta China sobre papel	32.00	44.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
466	4806	El ánimo del hacedor número 4806 técnica Tinta china, grafito marcadores y acuarela sobre papel Dimensión 32 × 47 cm. Año 2010	Tinta china, grafito y acuarela sobre papel	32.00	47.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
467	4834	Papel de prueba número 4834 técnica tinta china y aguada sobre papel dimensión 23.5 × 32 cm año 2010	Acuarela y Tinta China sobre papel	23.50	23.00	\N	\N	innovador, no costumbrista	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
468	4900	Camina! número 4900 técnica tinta y acuarela sobre papel dimensión 37 × 27 cm Año 2010	Acuarela y Tinta China sobre papel	37.00	27.00	\N	Don Quijote de la mancha	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
469	4777	En busca de lo mismo número 4777 técnica grafito y acuarela sobre papel dimensión 37 × 27 cm año 2010	Grafito y acuarela sobre papel	37.00	37.00	\N	Don Quijote de la mancha	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
470	4829	Don Quijote número 4829 técnica grafito y aguada sobre papel di mención 40.5 × 30 cm año 2010	Grafito y acuarela sobre papel	40.50	40.00	\N	Don Quijote de la mancha	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
471	1299	Holsman Margariteño Número 1299 técnica pinta y acuarela sobre papel dimensión 34 × 24 cm año 1995	Acuarela y Tinta China sobre papel	34.00	24.00	\N	Holsman Margariteño	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
472	\N	Holsman Margariteño Número 1299 técnica pinta y acuarela sobre papel dimensión 34 × 24 cm año 1995	Acuarela y Tinta China sobre papel	34.00	24.00	\N	Holsman Margariteño	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
473	3312	El bello pasado Ñero (copia de copia) número 3312 técnica aguada con tinta china sobre papel dimensión de la copia 28 × 22 cm año 2005	Acuarela y Tinta China sobre papel	28.00	28.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
474	3294	Sardinas número 3294 técnica tinta china sobre papel dimensión 21 × 29.5 cm año 2005	Tinta China sobre papel	21.00	29.50	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
475	2397	Pareja de pescadores la guardia número 2397 técnica aguada con tinta china sobre papel dimensión 23 × 30.5 cm año 1995	Acuarela y Tinta China sobre papel	23.00	30.50	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
476	3121	La viejita en San Sebastián número 3121 técnica aguada con grafito dimensión 19 × 26 cm año 1981	Grafito y acuarela sobre papel	19.00	19.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
477	4357	Se acomodó el día apunte viejo número 4357 técnica grafito sobre papel dimensión 21.5 × 30.5 cm año 2009	Grafito sobre papel	21.50	21.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
478	943	Carmen Yanez carapacho número 943 técnica aguada con grafito sobre papel dimensión 27 × 35 cm año 1991	Grafito y acuarela sobre papel	27.00	27.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
479	4359	Adiós apunto viejo número 4359 técnica tinta azul sobre sobre papel dimensión 21.5 × 30.5 cm año 2009	tinta azul sobre papel	21.50	21.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
480	\N	Sin nombre sin número pez con Margarita Egna y gentilicio Margarita técnica tinta china sobre papel dimensión 28 x 38.5 cm año 1989	Tinta China sobre papel	28.00	38.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
481	1986	Cayita 1986 el tirano número 2119	\N	\N	\N	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
482	\N	Técnica tinta china con aguada sobre papel dimensión 28 × 34.5 cm año 1999	Acuarela y Tinta China sobre papel	28.00	34.50	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
483	5890	El sobre el hombro ella sobre la cabeza número 5890 técnica cinta y agua sobre papel dimensión 22 × 30 cm año 2016	Acuarela y Tinta China sobre papel	22.00	22.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
484	5848	trapiche culero número 5848 técnica tinta sobre papel dimensión 34 × 28 cm año 2016	Tinta China sobre papel	34.00	28.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
485	5889	Pescadores número 5889 técnica aguada y tinta sobre papel dimensión 22 × 30 cm año 2016	Acuarela y Tinta China sobre papel	22.00	30.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
486	5891	La tiran era número 5891 técnica agua sobre papel dimensión 21.5 × 30.5 cm año 2016	Acuarela sobre papel	21.50	30.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
487	5862	Cargando agua número 5862 técnica agua sobre papel dimensión 30 × 42 cm año 2016	Acuarela sobre papel	30.00	42.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
488	5879	Mamitis número 5879 técnica tinta china sobre papel dimensión 34.5 × 21.5 cm año 2016	Tinta China sobre papel	34.50	5.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
489	3807	Dame jugo por favor número 3807 técnica pinta y agua sobre el papel dimensión 24 × 32.5 cm año 2005	Acuarela y Tinta China sobre papel	24.00	24.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
490	5003	La vendepescado número 5003 técnica aguada sobre papel dimensión 16.5 × 28 cm año 2011	Acuarela sobre papel	16.50	28.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
491	5046	Pesando el pescado número 5046 técnica tinta china y aguada sobre papel dimensión 21.5 × 28 cm año 2011	Acuarela y Tinta China sobre papel	21.50	21.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
492	5171	El baile número 5171 técnica grafito tinta aguada sobre papel dimensión 23 × 31.5 cm año 2012	Acuarela y Tinta China sobre papel	23.00	31.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
493	1038	Mi abuelita vende pelao número 1038 técnica tinta sobre papel dimensión 24 × 31.5 cm año 1991	Tinta China sobre papel	24.00	31.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
494	3859	El entierro número 3859 técnica y aguada sobre papel dimensión 47 × 32 cm año 2007	Acuarela y Tinta China sobre papel	47.00	32.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
495	4477	El componedor de pescado número 4477 técnica tinta aguada sobre papel dimensión 29.5 × 45.5 cm año 2009	Acuarela y Tinta China sobre papel	29.50	29.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
496	32	Mami cómprame un celular sin número técnica grafito y aguada sobre papel dimensión 32 × 45 cm año 2010	Grafito y acuarela sobre papel	45.00	32.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
497	4759	Trabajamos ambo número 4759 técnica aguada y tinta sobre papel dimensión 30 × 43.5 cm año 2010	Acuarela y Tinta China sobre papel	30.00	43.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
498	4746	Mi bisnieta chela número 4746 técnica aguada y tinta sobre papel dimensión 32 × 44.5 cm año 2010	Acuarela y Tinta China sobre papel	32.00	32.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
499	4701	El sábado del cochino número 4701 técnica tinta sobre papel dimensión 29.5 × 35 cm año 2010	Tinta China sobre papel	29.50	5.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
500	4232	En los gallos de Guatamare número 4232 técnica pinta y aguada sobre papel dimensión 36.5 × 27 cm año 1985	Acuarela y Tinta China sobre papel	36.50	36.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
501	4761	Las viejitas en el DW el número 4761 técnica tinta y aguada sobre papel dimensión 28.5 × 21 cm año 2010	Acuarela y Tinta China sobre papel	5.00	21.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
502	4334	La conversa número 4334 técnica tinta sobre papel dimensión 37 × 27 cm año 2009	Tinta China sobre papel	37.00	27.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
503	4335	Encuentro en el campo número 4335 técnica tinta sobre papel di mención 27 × 37 cm año 2009	Tinta China sobre papel	27.00	27.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
504	4166	El Vigía número 4166 técnica tinta y agua sobre papel dimensión 30 y 1 × 44 cm año 2008	Acuarela y Tinta China sobre papel	1.00	1.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
505	931	Julia García pedregales número 931 técnica grafito y agua sobre papel dimensión 24 × 31.5 cm año 1991	Grafito y acuarela sobre papel	24.00	24.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
506	346	Manuela Natera Santana número 346 técnica grafito y aguada sobre papel dimensión 27 × 35 cm año 1991	Grafito y acuarela sobre papel	27.00	27.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
507	2081	El mundo de Carlota el cercado número 2081 técnica grafito sobre papel dimensión 29.5 × 42 cm año 1999	Grafito sobre papel	29.50	29.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
508	929	Alpargatas se furriquete de Silverio Rodríguez Altagracia número 929 técnica grafito y agua sobre papel dimensión 24 × 31.5 cm año 1991	Grafito y acuarela sobre papel	24.00	24.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
509	5268	Rafael cadenas número 5268 técnica sanguina dimensión 16.5 × 22.5 cm año 1991	Sanguina sobre papel	16.50	22.50	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
510	5733	Monsenor Jorge Anibal Quintero número 5733 técnica sanguina Quellón sobre papel dimensión 21.5 × 30.5 cm año 2014	Sanguina y Creyón sobre papel	21.50	21.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
511	4427	Recordando al negro Bolivar ostras y perlas número 4427 técnica tinta china sobre papel dimensión 28 × 34.5 cm año 2009	\N	28.00	34.50	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
578	2594	Por baruta número 2594 técnica grafito y acuarela sobre papel dimensión 40.5 × 29.5 cm año 2003	Grafito y acuarela sobre papel	40.50	5.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
512	4284	El maestro Lucena número 4284 técnica tinta y aguada sobre papel dimensión 26 × 39.5 año 2009	Acuarela y Tinta China sobre papel	26.00	26.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
513	4118	Reverón número 4118 técnica aguada y tinta china sobre papel dimensión 32 × 45.5 cm año 2008	Acuarela y Tinta China sobre papel	32.00	45.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
514	28	Bolivar Copia sin número. Tinta sobre papel dimensión 28 × 35.5 cm año 1992	Tinta China sobre papel	28.00	35.50	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
515	2988	No tiene nombre es una composición de historia de Venezuela copia número 2988 año 2005	Tinta China sobre papel	\N	\N	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
516	5430	Sin nombre hombre en el Piñero número 5430 técnica pinta sobre papel dimensión 21.5 × 28 cm año 2013	Tinta China sobre papel	21.50	21.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
517	21	Sin nombre hombre en el pañero la mujer conversa técnica tinta sobre papel dimensión 21.5 × 28 cm año 2013	Tinta China sobre papel	5.00	21.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
518	4431	Sin nombre hombre la familia número 4431 técnica tinta sobre papel dimensión 21.5 × 28 cm año 2013	Tinta China sobre papel	21.50	21.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
519	5432	Sin nombre los pescadores número 5432 técnica tinta sobre papel dimensión 21.5 × 28 cm año 2013	Tinta China sobre papel	21.50	5.00	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
520	528	Copia Casa Margariteña	tinta china sobre papel	\N	\N	\N	oficio y gentilicio de Margarita	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
521	40	Serigrafía vivencias del pueblo Pescadores después de la jornada Porlamar 40 de 200 tinta técnica china sobre papel Dimensión 23 × 30 cm año 1981	Tinta China sobre papel	23.00	200.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
522	119	Serigrafía vivencias del pueblo paisaje estero mata de dátil agua de vaca 119 de 200 técnica tinta china sobre papel dimensión 28× 21 cm año 1981	Tinta China sobre papel	200.00	119.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
523	9	Serigrafía vivencias del pueblo paisaje estero mata de dátil agua de vaca 9 de 200 técnica tinta china sobre papel dimensión 28× 21 cm año 1981	Tinta China sobre papel	200.00	9.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
524	119	Serigrafía vivencias del pueblo oficio femenino mata de coco criollo 119 de 200 técnica tinta china sobre papel dimensión 21× 30 cm año 1980	Tinta China sobre papel	200.00	200.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
525	9	Serigrafía vivencias del pueblo oficio femenino mata de coco criollo 9 de 200 técnica tinta china sobre papel dimensión 21× 30 cm año 1980	Tinta China sobre papel	200.00	200.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
526	40	Serigrafías vivencias del pueblo encuentro en el Conuco con mata de coco enano la villa del Norte Santana 40 de 200 técnica tinta china sobre papel dimensión 21 × 28 cm año 1981	Tinta China sobre papel	21.00	40.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
527	40	serigrafía el viejo puente Luisa Cáceres de Arismendi en la Asunción 40 de 200 técnica tinta china sobre papel di mención 22.5 × 30 cm año 1981	Tinta China sobre papel	22.50	200.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
528	119	Serigrafías vivencias del pueblo venta de carne en el salado 119 200 técnica tinta china sobre papel di mención 22.5 × 33.5 cm año 1982	Tinta China sobre papel	22.50	22.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
529	65	Serigrafías vivencias del pueblo venta de carne en el salado 65 de 200 técnica tinta china sobre papel di mención 22.5 × 33.5 cm año 1982	Tinta China sobre papel	22.50	200.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
530	40	Serigrafía de Bahía de porLamar 40 de 200 técnica tinta china sobre papel di mención 24 × 35 cm año 1979	Tinta China sobre papel	24.00	24.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
531	9	Serigrafía de Bahía de porLamar 9 de 200 técnica tinta china sobre papel di mención 24 × 35 cm año 1979	Tinta China sobre papel	24.00	24.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
532	40	Serigrafía vivencias del pueblo venta de pollos en ParaguayChi 40 de 200 técnica tinta china sobre papel dimensión 23 × 34 cm año 1981	Tinta China sobre papel	23.00	23.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
533	9	Serigrafía vivencias del pueblo venta de pollos en ParaguayChi 9 de 200 técnica tinta china sobre papel dimensión 23 × 34 cm año 1981	Tinta China sobre papel	23.00	23.00	\N	\N	serigrafía	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
534	4321	Interpretación gráfica de la espinela en el estilo de Matisse número 4321 tinta china con acuarela sobre papel dimención 47 × 32 cm año 2009	Acuarela y Tinta China sobre papel	47.00	47.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
535	10	Interpretación gráfica de la espinela la 10ª nuestra copia número 4314 técnica tinta china sobre papel dimensión 28 × 21.5 cm año 2009	Tinta China sobre papel	28.00	28.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
536	4737	El tono hace la música número 4737 técnica tinta china y agua sobre papel dimensión 21.5 × 28 cm año 2011	Acuarela y Tinta China sobre papel	5.00	28.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
537	4263	Los Roques número 4263 técnica oil pastel dimensión 32 × 23.5 cm año 2008	Oil Pastel sobre papel	32.00	23.50	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
538	4822	Jazz ZZZ número 4822 técnica tinta china y aguada sobre papel dimensión 27 × 37 cm año 2010	Acuarela y Tinta China sobre papel	27.00	27.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
539	4450	Tocando un cuatro número 4450 técnica pinta China y acuarela sobre papel dimensión 23.5 × 32 cm año 2009	Acuarela y Tinta China sobre papel	23.50	23.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
540	4319	Interpretación gráfica de la espinela en el estilo de Joan miro número 4319 técnica tinta china y acuarela sobre papel dimensión 47 × 32.5 cm año 2009	Acuarela y Tinta China sobre papel	47.00	32.50	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
541	4320	Interpretación gráfica de la espinela en el estilo Picasso número 4320 técnica tinta china y agua sobre papel dimensión 47 × 32.5 cm año 2009	Acuarela y Tinta China sobre papel	47.00	47.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
542	4322	Interpretación gráfica de la espinela en el estilo de Dalí número 4322 técnica tinta china y aguada sobre papel dimensión 47 × 32.5 cm año 2009	Acuarela y Tinta China sobre papel	47.00	47.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
543	4307	Interpretación gráfica de la espinela tema Cuba agua número 4307 técnica tinta china y acuarela sobre papel dimensión 37 × 27 cm año 2009	Acuarela y Tinta China sobre papel	37.00	37.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
544	4311	Interpretación gráfica de la espinela tema las décimas sacadas de un kilo de estopa número 4311 Técnica tinta y aguada sobre papel dimensión 37 × 27 cm año 2009	Acuarela y Tinta China sobre papel	37.00	27.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
545	1930	Año 1930 charlestón número 5043 técnica tinta china y aguada sobre papel dimensión 45.5 × 33 cm año 2011	Acuarela y Tinta China sobre papel	45.50	45.00	\N	Música	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
546	2897	Olomouc número 2897 técnica grafito sobre papel dimensión 21 × 30 cm año 2004	Grafito sobre papel	21.00	30.00	\N	Europa	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
547	4533	Pueblito en Suiza número 4533 Técnica acuarela sobre papel dimensión 36 × 29 cm año 2009	Acuarela sobre papel	36.00	29.00	\N	Europa	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
548	2898	Praga número 2898 técnica grafito sobre papel dimensión 21 × 29.5 cm año 2004	Grafito sobre papel	21.00	29.50	\N	Europa	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
549	2183	En Dinamarca número 2183 técnica grafito sobre papel dimensión 21 × 29.5 cm año 2000	Grafito sobre papel	21.00	29.50	\N	Europa	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
550	3302	Praga número 3302 técnica tinta china sobre papel dimensión 29.5 × 21 cm año 2005	Tinta China sobre papel	29.50	21.00	\N	Europa	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
551	985	Macuro la casita del banco Venezuela y biblioteca número 985 técnica grafito sobre papel dimensión 35.5 × 25 cm año 1992	Grafito sobre papel	5.00	25.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
552	5719	Macuro número 5719 técnica grafito sobre papel y mención 23 × 18 cm sin año	Grafito sobre papel	23.00	18.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
553	2324	Río Grande estado Bolívar número 2324 técnica grafito y agua sobre papel dimensión 31. 5 × 24 cm año 2001	Grafito y acuarela sobre papel	5.00	31.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
554	1967	Si nada Maica 1967 número 2760 técnica grafito sobre papel dimensión 21 × 30 cm sin año	Grafito sobre papel	21.00	30.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
555	2187	Delta Orinoco Número2187 técnica grafito y creyó sobre papel dimensión 27.5 × 21 cm año 2000	Grafito y Creyón sobre papel	27.50	21.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
556	2848	El castillo de Araya número 2848 técnica acuarela sobre papel dimensión 29.5 × 21.5 cm año 2004	Acuarela sobre papel	29.50	5.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
557	2508	Maracaibo número 2508 técnica grafito y acuarela sobre papel dimensión 21 × 29.5 cm año 2012	Grafito y acuarela sobre papel	21.00	5.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
558	2637	El junco número 2637 técnica grafito y acuarela sobre papel dimensión 30.5 × 23 cm año 2003	Grafito y acuarela sobre papel	30.50	5.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
559	2634	El junco número 2634 técnica grafito y acuarela sobre papel dimensión 34.5 × 23 cm año 2003	Grafito y acuarela sobre papel	34.50	5.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
560	2403	Sínamaica número 2403 técnica pinta y acuarela sobre papel dimensión 21 × 29.5 cm. Año 1996	Acuarela y Tinta China sobre papel	21.00	5.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
561	4408	Laguna de raya número 4408 técnica tinta china sobre papel dimensión 28.5 × 21 cm año 2009	Tinta China sobre papel	28.50	5.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
562	1950	En Carabobo por 1950 número 3106 técnica grafito sobre papel dimensión 18 × 22 cm año 2005	Grafito sobre papel	18.00	22.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
563	2614	La gran Sabana número 2614 técnica grafito sobre papel dimensión 20.5 × 29.5 cm año 2002 (esta obra tiene por la parte de atrás apunte de la plaza Tacarigua igual en Maracay una figura de Alejandro Colina)	Grafito sobre papel	20.50	29.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
564	2948	Única número 2948 técnica tinta sobre papel dimensión 23 × 27 cm año 2004	Tinta China sobre papel	23.00	27.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
565	1735	Los llanos en época de lluvia estado Bolívar número 1735 técnica grafito sobre papel dimensión 21 × 29.5 cm año 1998	Grafito sobre papel	21.00	29.50	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
566	3385	Posada la acacia en Morrocoy Número 3385 técnica grafito sobre papel dimensión 22 × 19 cm año 2005	Grafito sobre papel	22.00	22.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
567	4249	Paraguaná número 4249 técnica oil pastel dimensión 32 × 23.5 cm año 2008	Oil Pastel sobre papel	32.00	23.50	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
568	4003	TepuYes número 4003 técnicas oil pastel dimensión 24 × 21 cm año 2008	Oil Pastel sobre papel	24.00	21.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
569	4251	El acueducto en Aragua número 4251 técnica oil pastel dimensión 32 × 29.5 cm año 2008	Oil Pastel sobre papel	32.00	5.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
570	3901	Finca Catuma en Aragua número 3901 técnica acuarela sobre papel dimensión 45 × 30.5 cm año 2007	Acuarela sobre papel	45.00	30.00	\N	pueblos y ciudades en Venezuela	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
571	s/n	Hacienda la faltriquera	Grafito y acuarela sobre papel	\N	\N	2003	\N	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
572	2842	El Azteca mogo número 2842 técnica acuarela sobre papel dimensión 18.5 × 27.5 cm año 2004	Acuarela sobre papel	18.50	27.00	\N	figuras prehistóricas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
573	3788	El Vennus lacustre Yara número 3788 técnica acuarela sobre papel dimensión 30 × 42 cm año 2007	Acuarela sobre papel	30.00	42.00	\N	figuras prehistóricas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
574	4253	La Venus lacustre número 4253 técnica Creyón de cera di mención 32 × 43.5 cm año 2008	Creyón de cera sobre papel	32.00	43.00	\N	figuras prehistóricas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
575	4865	La Venus lacustre número 4865 técnica Tinta China y acuarela sobre papel dimensión 32 × 44 cm año 2010	Acuarela y Tinta China sobre papel	32.00	32.00	\N	figuras prehistóricas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
576	4375	La Venus lacustre de Alejandro Colina número 4375 técnica tinta china y agua sobre papel dimensión 32 × 47 cm año 2009	Acuarela y Tinta China sobre papel	32.00	47.00	\N	figuras prehistóricas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
577	4116	La Venus lacustre de Alejandro Colina	Acuarela y Tinta China sobre papel	\N	\N	2008	figuras prehistóricas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
579	4473	Árbol sobre el muro en el Caracas Sport club número 4473 técnica grafito sobre papel dimensión 24 × 32.5 cm año 2013	Grafito sobre papel	24.00	24.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
580	5723	Casa Zitman en la Trinidad número 5723 técnica grafito sobre papel dimensión 30.5 × 21.5 cm año 2014	Grafito sobre papel	30.50	30.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
581	3162	Museo bellas artes jardín número 3162 técnica grafito sobre papel dimensión 35.5 × 28 cm año 2005	Grafito sobre papel	35.50	5.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
582	1953	Calle la línea en 1953 Caracas número 1989 técnica grafito sobre papel di mención 22.5 × 30 cm 1975	Grafito sobre papel	22.50	30.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
583	1979	Teatro Ayacucho Caracas 1979 número 1758 técnica grafito sobre papel dimensión 24 × 31. 5año 1999	Grafito sobre papel	24.00	31.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
584	1821	petroglifos en la Esmeralda cerca de baruta número 1821 técnica tinta china y acuarela sobre papel di mención 28.5 × 41 cm año 1999	Acuarela y Tinta China sobre papel	28.50	28.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
585	2098	El metro caraqueño número 2098 técnica tinta china y acuarela sobre papel estilo CS Praga dimensión 40.5 × 29.5 cm año 2000	Acuarela y Tinta China sobre papel	40.50	40.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
586	1988	La viejita recoge peroles en pleno centro de Caracas 1988 número 2058 técnica grafito sobre papel dimensión 24 × 31.5 cm año 1999	Grafito sobre papel	24.00	24.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
587	1960	El pescaito baruta 1960 número 1640 técnica grafito y acuarela sobre papel dimensión 22.5 × 30 cm año 1995	Grafito y acuarela sobre papel	22.50	22.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
588	1642	El curioso Nicanor en la Corraleja bodega de ángel Rosales baruta número 1642 técnica grafito y agua sobre papel dimensión 24 × 32.5 cm año 1998	Grafito y acuarela sobre papel	24.00	32.50	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
589	2593	Por baruta mientras estaba en la cola para conseguir gasolina para mi carro número 2593 técnica grafito y acuarelas sobre papel dimensión 40.5 × 29 cm año 2003	Grafito y acuarela sobre papel	40.50	29.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
590	5725	Bosque de la virgen baruta número 5725 técnicas acuarela sobre papel dimensión 30 × 42 cm año 2013	Acuarela sobre papel	30.00	30.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
591	4244	Petroglifos las esmeraldas número 4244 técnica Creyón sobre papel dimensión 32 × 47 cm año 2008	Creyón sobre papel	32.00	47.00	\N	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
592	4685	El torero del nuevo circo	Acuarela y Tinta China sobre papel	\N	\N	2010	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
593	5532	Las tres gracias	Acuarela y Tinta China sobre papel	\N	\N	2014	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
594	5147	Las tres gracias con samba	Acuarela y Tinta China sobre papel	\N	\N	2014	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
595	5540	Ahora Guaraira Repano	Tinta China sobre papel	\N	\N	2014	Caracas	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
596	2793	Bromelias número 2793 técnica acuarela Y grafito sobre papel dimensión 30 × 22.5 cm año 2004	Grafito y acuarela sobre papel	30.00	5.00	\N	naturaleza general	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
597	4064	No me olvides número 4064 técnica oil pastel dimensión 32.5 × 23.5 cm año 2007	Oil Pastel sobre papel	32.50	5.00	\N	naturaleza general	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
598	4130	Los Araguaneyes Número 4130 técnica acuarela sobre papel dimensión 32 × 23.5 cm año 2008	Acuarela sobre papel	32.00	23.50	\N	naturaleza general	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
599	4845	Mango número 4845 técnica acuarela sobre papel dimensión 23.5 × 32 cm año 2010	Acuarela sobre papel	23.50	32.00	\N	naturaleza general	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
600	5754	Tapara número 5754 técnica tinta china y acuarela sobre papel dimensión 21.5 x 14.5 cm año 2014	Acuarela y Tinta China sobre papel	21.00	5.00	\N	naturaleza general	\N	Caracas	\N	331	2026-10-13 01:32:13.739554	2026-10-13 01:32:13.739554
601	5728	Frangipani número 5728 técnica tinta china y acuarela sobre papel dimensión 14 × 21.5 cm año 2014	Acuarela y Tinta China sobre papel	14.00	21.00	\N	naturaleza general	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
602	4202	Amapolas número 4202 Oil pastel sobre papel dimensión 45.5 × 32 cm año 2008	Oil Pastel sobre papel	45.50	32.00	\N	naturaleza general	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
603	5749	Amapolas número 5749 técnicaAcuarela sobre papel dimensión 42 × 30 cm año 2014	Acuarela sobre papel	42.00	30.00	\N	naturaleza general	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
604	7	Gran jefe indio calcular 7 × 8 igual 56 técnica base de acuarela y dibujo en tinta china y mención 26.5 × 37 cm año 2013	Acuarela y Tinta China sobre papel	26.50	26.00	\N	\N	Obras con leyendas explicativas	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
605	5443	Sin nombre ropa guindada del Sol número 5443 técnica base en acuarela y dibujo en tinta china dimensión 20.5 × 19.5 cm año 2013	Acuarela y Tinta China sobre papel	20.50	20.00	\N	\N	Obras con leyendas explicativas	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
606	4444	El dinero no se come número 4444 técnica tinta china sobre papel dimensión 44.5 × 28 cm año 2009	Tinta China sobre papel	44.50	44.00	\N	\N	Obras con leyendas explicativas	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
607	4983	La construcción de una nación es cumplir con los tres vértices número 4983 técnica tinta china y acuarela sobre papel dimensión 29.5 × 30 cm año 2011	Acuarela y Tinta China sobre papel	29.50	30.00	\N	\N	Obras con leyendas explicativas	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
608	5438	Cómo quedo yo que hay pa eso número 5438 técnica tinta china y acuarela sobre papel dimensión 30 × 42 cm año 2013	Acuarela y Tinta China sobre papel	30.00	30.00	\N	\N	Obras con leyendas explicativas	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
609	3949	La madera en el banco de la capilla número 3949 técnica acuarela y grafito sobre papel dimensión 45.5 × 30.5 cm año 2007	Grafito y acuarela sobre papel	45.50	45.00	\N	\N	Superficies	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
610	3935	Arena playera danesa figurativa Número 3935 técnica acuarela sobre papel dimensión 43 × 31 cm año 2007	Acuarela sobre papel	43.00	31.00	\N	\N	Superficies	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
611	3934	La arena playera danesa pintan laberintos número 3934 técnica acuarela sobre papel dimensión 46 × 31 cm año 2007	Acuarela sobre papel	46.00	46.00	\N	\N	Superficies	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
612	1807	Apunte número 1807 personajes técnica grafito sobre papel dimensión 35.5 × 28 cm sin año	Grafito sobre papel	35.50	28.00	\N	\N	Apunte	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
613	5441	El museo de aguantar número 5441 técnica grafito y tinta china sobre papel dimensión 20 × 28 cm año 2013	Grafito y tinta china sobre papel	20.00	20.00	\N	\N	Apunte	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
614	2944	Apunta la gente número 2944 técnica grafito sobre papel dimensión 19.5 × 29.5 cm sin año	Grafito sobre papel	19.50	29.00	\N	\N	Apunte	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
615	2686	Coche número 2686 técnica grafito sobre papel dimensión 19.5 × 29 cm sin año	Grafito sobre papel	19.50	29.00	\N	\N	Apunte	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
616	4356	Piernas femeninas número 4356 técnica tinta sobre papel dimensión 30.5 × 20.5 cm sin año	Tinta China sobre papel	30.50	5.00	\N	\N	Apunte	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
617	2660	Artista número 2660 técnica gráfico sobre papel dimensión 27 × 37.5 cm año 2003	Grafito sobre papel	27.00	37.50	\N	\N	Apunte	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
618	1841	Apunta número 1841 personas técnica grafito sobre papel dimensión 33 × 24 cm sin año	Grafito sobre papel	33.00	24.00	\N	\N	Apunte	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
619	1980	Apuntes cargando y encargando de los años 1980 número 2085 técnica grafito sobre papel dimensión 24 × 32.5 cm año 1999	Grafito sobre papel	24.00	32.50	\N	\N	Apunte	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
620	2051	Basquet Pueblerino Pedro González en 1977	Acuarela y Tinta China sobre papel	24.00	30.50	1999	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
621	4735	El ponche político	Grafito sobre papel	28.00	21.50	2010	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
622	4707	Béisbol 4	Acuarela sobre papel	40.50	26.50	2010	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
623	5416	Taichi	Acuarela y Tinta China sobre papel	30.00	42.00	2013	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
624	5147	Taichi	Acuarela y Tinta China sobre papel	41.00	29.50	2011	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
625	5184	Taichi	Acuarela y Tinta China sobre papel	29.50	40.50	2012	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
626	5166	Taichi	Acuarela y Tinta China sobre papel	30.00	42.00	2011	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
627	5415	Taichi	Acuarela y Tinta China sobre papel	29.00	40.00	2013	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
628	5178	Taichi	Acuarela y Tinta China sobre papel	31.50	40.00	2011	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
629	5182	Taichi	Acuarela y Tinta China sobre papel	40.00	32.00	2012	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
630	5176	Taichi	Acuarela y Tinta China sobre papel	32.00	40.00	2011	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
631	5417	Taichimanía	Acuarela y Tinta China sobre papel	42.00	30.00	2013	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
632	5177	Taichi	Acuarela y Tinta China sobre papel	32.00	40.00	2012	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
633	5175	Taichi	Acuarela y Tinta China sobre papel	40.00	32.00	2011	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
634	5179	Taichi	Acuarela y Tinta China sobre papel	32.50	40.00	2012	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
635	5181	Taichi	Acuarela y Tinta China sobre papel	32.00	40.00	2012	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
636	5170	Los barbudos	Acuarela y Tinta China sobre papel	17.00	26.00	2011	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
637	5167	Taichi	Acuarela y Tinta China sobre papel	35.00	23.50	2012	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
638	5168	Taichi	Acuarela y Tinta China sobre papel	17.50	23.50	2011	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
639	5172	Taichi y el sol	Acuarela y Tinta China sobre papel	23.00	25.50	2012	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
640	5173	Taichi	Acuarela y Tinta China sobre papel	40.00	32.00	2012	Deportes	\N	Caracas	\N	331	2026-10-13 01:32:13.746587	2026-10-13 01:32:13.746587
\.


--
-- Data for Name: participante; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.participante (id_participante, nombre, cedula, fecha_nacimiento, correo, ciudad, instagram, estado_id) FROM stdin;
1	Adargelis Zecchinel	27403481	2000-07-09	zecchinel09@gmail.com	Juan Griego, Margarita	adargelis_zecchinel	18
2	Adriana Guerra	20049867	1992-05-18	adnastyle@gmail.com	Barcelona	\N	2
3	Adriana Martinez	13443147	1973-12-10	a1d2ry@gmail.com	Upata	\N	6
4	Aisha Alessandra Bravo Serje	33070478	2008-09-13	paoserje@gmail.com	Porlamar, Margarita	pao_aisha	18
5	Aismar Castillo	28468337	2000-05-24	aismardesign@gmail.com	Porlamar, Margarita	aismarc	18
6	Alan Rincón	33568846	2009-05-31	laviniavichenza@gmail.com	Altamira de Cáceres	\N	5
7	Albany Cedeño-Perez	\N	2013-06-26	alvarocedeno85@gmail.com	Guanare	\N	19
8	Alejandra Franco	32769620	2007-05-23	alejandranaomisfr@gmail.com	Porlamar, Margarita	\N	18
9	Alejandra Noriega	310617350	2003-08-02	celestenori14@gmail.com	Juan Griego, Margarita	\N	18
10	Alejandra Rivadulla	29591403	2002-03-29	alejandracrivadulla@gmail.com	Porlamar, Margarita	\N	18
11	Alejandro Fernández	31204386	2005-02-01	alejandroemiliofernandezcaro@gmail.com	Independencia	\N	23
12	Alessandro Ceci Castillo	32723169	2007-08-16	algaceca@gmail.com	Pampatar	\N	18
13	Alexia Ávila	33926618	2011-03-24	arianasalazarindriago@hotmail.com	Las Villarroeles Municipio Diaz	\N	18
14	Alfonso Pinto	18528332	1986-12-23	drums86ink@gmail.com	Juan Griego, Margarita	\N	18
15	Alison Manaure	28279574	1999-02-01	alisonmtenias@gmail.com	La Asunción	\N	18
16	Alix Delgado Hernández	14942428	1980-05-20	arolena22@hotmail.com	San Cristóbal	\N	21
17	Almariz Echenique	26113637	1998-08-31	almarizechenique27@gmail.com	Valles del Tuy	\N	16
18	Amanda Santana	32111233	2006-07-19	sp.amanda19@gmail.com	Caracas	\N	10
19	Amilcar Fermín	18223245	1986-11-10	amilcarjff@gmail.com	Caracas	amilcardrawing	10
20	Ana Mercedes Moya Caraballo	8399273	1965-09-24	anamercedesmoyac@gmail.com	Paraguachí	\N	18
21	Anabell Prescott	6559850	1963-01-29	anabellprescott@gmail.com	Caracas	anabellprescott.r	10
22	Ananda Manzanilla	32938424	2008-09-30	manzanilla2008ananda@gmail.com	La Playa	\N	18
23	Andrea Chersia	25687767	1997-02-15	chersiandrea@gmail.com	La Asunción	\N	18
24	Andrea Hernández Guerrero	35067258	2012-04-30	guerreromariilla@gmail.com	San Cristóbal	\N	21
25	Andrea Travieso G.	31893732	2007-03-14	andyprincessfrozen@gmail.com	Turmero	\N	4
26	Andrea Vargas	32495364	2008-02-16	jessicajennyh@gmail.com	Porlamar, Margarita	\N	18
27	Andrés Ignacio Rojas Zerpa	34285066	2012-09-25	rmtallerdearte@gmail.com	Santa Cruz de Mora	\N	15
28	Andy José Rodríguez Hernández	9428506	1969-09-01	andylustracion@gmail.com	La Victoria	\N	4
29	Angel Antonio Rojas Ferrer	31649026	2006-12-20	rojas2006angel@gmail.com	El salado	\N	18
30	Angel Castillo	33548796	2010-09-30	angelcastillonegrin@gmail.com	Porlamar, Margarita	\N	18
31	Angelo Labrador	\N	2012-12-20	dannedys@hotmail.com	La Asunción	\N	18
32	Annelisse del Valle Verde	31502830	2006-08-12	lisandro.verde@gmail.com	La Vecindad	\N	18
33	Anthony Pérez	24689203	1995-03-17	Anthonyjtony1995@gmail.com	Casanay	\N	20
34	Antonella Di Salvo	33062933	2009-07-09	antonelladisalvog@gmail.com	La Asunción	\N	18
36	Antonio José Villamizar González	5640409	1958-12-01	arolena22@hotmail.com	Las Vegas de Tariba	\N	21
37	Antonio Manzanilla	5763515	1962-12-29	manzanilla1962@gmail.com	La Playa	\N	18
38	Antonio Sebastian Gonzalez Hernandez	30685248	2003-05-29	antoniosebastian2571@gmail.com	Juan Griego, Margarita	\N	18
40	Bárbara Acevedo	29680459	2003-02-14	braceriv@gmail.com	Isla de Margarita	braceriv	18
41	Beatriz Araxa Sucre Munoz	23789180	1994-03-14	lossucresca@gmail.com	Maracay	araxaart	4
42	Brayan Antonio Ojeda Coronado	32980595	2006-08-07	yaccelis_miss@hotmail.com	San Diego	yaccelis coronado	7
43	Brayan Rojas	29545046	2001-07-20	hablaclaro231@gmail.com	Tariba	Brayanroj_	21
44	Camila Velandia	32051624	2007-08-11	miavelandia@gmail.com	El salado, Antolín del campo	Camilavvalerio11	18
45	Carlos Luis Sánchez Becerra	17462106	1987-07-18	majenye@gmail.com	Carora	majenye	14
46	Carmen Urbina Mendez	3998075	1951-12-09	reflejo11@gmail.com	San Cristóbal	curbina_art	21
47	Cecilio Brito	10197375	1968-11-22	ceciliobrito1@hotmail.com	La Asunción	\N	18
48	Cesar Cabrera	12920155	1976-10-04	cesarunner04@gmail.com	La Asunción	Cesarcabrera0410	18
49	César Gomez	14275355	1981-02-09	cesart10858@hotmail.com	Caracas	cesart10858	10
51	Chiquinquirá Del Valle Natera Moya	26087422	1997-12-29	cnateramoya@gmail.com	Paraguachí	chiquinatera	18
52	Christopher Heredia	28412837	2000-07-13	zz.ch18@gmail.com	Porlamar, Margarita	Chris_hdart	18
53	Claudia Ordaz	32680159	2007-02-15	claudia_ordaz@uecolegiojuangriego.com	Juan Griego, Margarita	\N	18
54	Crisanto Romero	23867261	1993-04-12	crisantoromero93@gmail.com	San Juan Bautista	Khrizsaint	18
55	Cristina Ramírez libertella	30750112	2005-05-04	cristinaramirezl@hotmail.com	Porlamar, Margarita	\N	18
56	Cruz Rafael Higuerey Balza	7663491	1964-07-03	rafaelh3310@gmail.com	Paraguachí	cruzrafaelhiguerey	18
57	Daniel Ayala	\N	2015-05-13	yraismoras@gmail.com	Valencia	Yraismora30	7
58	Daniela Fernández	31445257	2006-02-06	dvraven06@gmail.com	Guayana	dvraven06	6
59	Daniela Millán	26479136	1997-02-19	danielamillan26479@gmail.com	Porlamar, Margarita	unaguanabana	18
60	Daniela Noriega	25967601	1997-07-12	danyangeles003@gmail.com	Juan Griego, Margarita	\N	18
61	Darle Brito	27650418	2000-09-15	darlepotterica@gmail.com	La Asunción	\N	18
63	Darlymar Gineth Martinez Contreras	27933735	2000-04-21	rmtallerdearte@gmail.com	Santa Cruz de Mora	darlymarmartinez	15
64	Daviana Soria	27341247	1998-11-01	davianasoria@hotmail.com	Valle Verde	Davii_1798	18
65	Daviangel Rafael Soria	27740682	2000-09-18	daviangelsoria@hotmail.com	Valle Verde	Soriarte_18	18
66	David Marquez	12783624	1974-03-18	davidmarquez415@gmail.com	Caracas	\N	10
67	David Castilla	31991744	2006-12-18	davidcastimar@gmail.com	Los Robles	\N	18
68	Decher Rincon	30753873	2004-07-20	rincondecher01@gmail.com	Altamira de Cáceres	\N	5
69	Diana Briceño	27453939	2000-08-05	dianabricenno@gmail.com	Maracay	Lavidaimitaalarte	4
62	Darlenys Castillo	13507570	1976-09-13	darlenyscastillo18@gmail.com, arq.darlenys.castillo@gmail.com	Pampatar	castledarte	18
39	Aquiles Mejia Bernard	34896461	2011-11-18	bernardelena@hotmail.com, elenabernardh@gmail.com	Pampatar	\N	18
70	Diana Gutiérrez	29789531	2003-03-12	dianacarolinalop318@gmail.com	Porlamar, Margarita	\N	18
71	Diego Carrillo	\N	2008-11-02	diegocarrillo804@gmail.com	Ciudad Bolívar	diegocarrillo804	6
72	Dilcia Martinez	8540253	1963-01-16	martinezdilcia@gmail.com	Upata	dilciamartinezr	6
73	Dionida Coromoto González de Rodelo	7685380	1963-02-23	coromotogonzalez_2010@hotmail.com	Porlamar, Margarita	coromoto.g	18
74	Dubraska Solórzano Valladares	26435618	1998-01-02	solorzano.dubraska@gmail.com	San Antonio de los Altos	\N	16
75	Edgar Daniel Narváez Rojas	30708038	2002-07-02	omairaf29@gmail.com	Altagracia	\N	12
76	Edgar Jiménez	\N	2014-07-22	olykarolina460@gmail.com	Isla de Margarita	olyvelasquez	18
77	Eduardo Batista	30020020	1998-02-19	eduardobatista1998@gmail.com	Valencia	ejboart	7
78	Eduardo Jiménez	12674878	1997-09-28	edujido@gmail.com	El Cercado	\N	18
79	Eduardo Larez	30563552	2003-05-26	eduardolarezmt@gmail.com	Tacarigua	eduartwtt	18
80	Eduardo Lovera	22764981	1992-12-22	loveraeduardo1@gmail.com	Caracas	eduardlovera	10
81	Eduardo Millán	31061914	2005-12-03	ejmmmillan30@gmail.com	Doña Elisa municipio García	\N	18
82	Eidember Rojas	27293495	1999-03-27	maximaxomaximaxo@gmail.com	San Félix	Nemite_me	6
83	Elisabet Noemi Osorio Ruesta	\N	2010-08-12	susanruestaosorio@gmail.com	Costa Azul	\N	18
84	Elizabeth Bracho	5305584	1959-12-13	ebrachotorres@gmail.com	Pampatar	Ebrachot.	18
85	Eloisa Victoria Figueroa Mijares	27352251	1997-11-20	Eloisafigueroafotos@gmail.com	La Vecindad	elo.figueroa	18
86	Emelins Teresa Rodríguez Mata	17899589	1988-09-28	mlinshek20@gmail.com	Juan Griego, Margarita	mlins88	18
87	Emmanuel Jiménez	26326649	1998-09-12	emmanuelmjg12@gmail.com	Los Robles	emmanuelvoz	18
88	Enmanuel Dionisio Savatore Pérez Delgado	\N	2012-10-05	dionicioperez@hotmail.com	Tariba	elartistasalvatore	21
89	Esmeralda Roa Prieto	\N	2011-11-24	emilyprieto2013@gmail.com	La Playa	\N	18
90	Fabiola Esther Figueroa Mijares	31638681	2004-07-30	mariafigueroamijares@gmail.com	Porlamar, Margarita	fabiola.esther04	18
91	Fabiola Pérez	30277392	2002-03-21	Fabiolaanyelinaperezcasadiego@gmail.com	El Dátil	\N	18
92	Fátima Del Valle Natera Moya	25156497	1996-06-07	fatinatera@gmail.com	Paraguachí	fatinatera	18
93	Fernando Contreras Quiñonez	30068124	2011-01-31	tq14679@gmail.com	La Playa	vivero_creativo	18
94	Fiorella Alessandra Maduro Vivas	\N	2012-05-08	lizmv69@gmail.com	Maneiro	\N	18
95	Francisco Osuna	34546186	2012-04-22	angelicavillabutt@hotmail.com	La Guardia, municipio Díaz	\N	18
96	Francisco Varela	31936936	2007-06-30	varelafranciscoantonio@gmail.com	Caracas	\N	10
97	Franco Emilio Valdivieso	18114280	1988-10-24	francopao28@gmail.com	San Antonio	haciendogarabatos	16
98	Frank David Salazar	27202651	1999-08-07	frankdavidsalazar99@gmail.com	San Pedro de Coche	frankdavidss	18
99	Freddy Fernández	9307218	1966-03-19	fgproyectos08@gmail.com	Pampatar	fgproyectos	18
100	Gabriela Adrián	28730418	2003-09-16	gabrielavaldiviezoadrian@gmail.com	La Asunción	\N	18
101	Gabriela Sofía Culpa Méndez	34317611	2011-12-06	glaudi25@gmail.com	Barcelona	gabrielaculpaart	2
102	Génesis Bárbara Gualtieri Cano	32534932	2007-11-17	genesisbgualtieric@gmail.com	Caracas	genesisbgualtieric	10
103	Geraldine Lachmann	23867415	1995-03-03	lachmann.geral@gmail.com	Porlamar, Margarita	gigelachmann	18
104	Geraldine Salazar	14841298	1979-10-14	yaris00ster@gmail.com	San Juan	\N	18
105	Gianna Brito Daruich	33923982	2011-05-02	cdaruich@gmail.com	Caracas	clevysdaruich	10
106	Ginia Fransheska Pérez Calderin	34162675	2012-03-26	calderinvirginia977@gmail.com	Guacuco municipio arimendi	giniaca	18
107	Giuliana Berbín	32274811	2007-11-12	tomasemoyam@gmail.com	Juan Griego, Margarita	\N	18
108	Guadalupe del Valle Jiménez	25967790	1997-05-28	guadalupe28597@gmail.com	El Cercado	lu_art05	18
109	Guadalupe Roa Prieto	\N	2011-11-04	emilyprieto2013@gmail.com	La Playa	\N	18
110	Gustavo Fernández	20538609	1992-05-27	thabo_fer@hotmail.com	Pedro González, Margarita	gusthabo5	18
111	Helena Chitty	3658353	1953-07-10	helenamaria1007@gmail.com	Caracas	\N	10
112	Hever Hernández	23858835	1995-09-28	heverhernn@gmail.com	Juan Griego, Margarita	heverhernn	18
113	Hikmat Tineo	31841524	2006-09-21	suarezhikmat@gmail.com	Antolín del Campo	\N	18
114	Iliana Sofia Méndez Contreras	33410630	2010-04-13	juliocesar.4@gmail.com	Cordero	\N	21
115	Irma Mejías	12996636	1976-10-05	esmeraldairma125@gmail.com	Guacara	esmeraldaima125	7
116	Isabela Rodríguez Stohr	29954921	2003-05-05	isarod2003@gmail.com	Caracas	\N	10
117	Isabella Victoria Pachano Álvarez	13821291	2007-12-11	isabellavpachano@gmail.com	Porlamar, Margarita	isxxbellxx_	18
118	Ivana Carolina Campos Perales	33267737	2008-12-20	ivacarolina08@gmail.com	Caracas	ivanacamposs_	10
119	Ivana Carolina Naranjo Aquino	30547793	2003-07-18	ivanacarolinanaranjoaquino@gmail.com	Porlamar, Margarita	ivanacaro_318	18
120	Ivon Delima de Díaz	8680396	1964-01-10	yanethdelima48@gmail.com	La Asunción	yanethivon1023	18
121	Jade Gadke	30547870	2003-10-29	jadegadke@gmail.com	Tacarigua	miuminiku	18
123	Jeckson Antunez	29876384	2002-08-22	jecksona265@gmail.com	Concepción- La Paz	\N	24
124	Jesús Alfredo Vivas Márquez	28151620	2001-10-08	em978030@gmail.com	La Playa	vivero_creativo	18
125	Jesús Aliendres	32264748	2006-11-09	aliendrescatamo.jr@gmail.com	Caracas	jjaazzyi	10
126	Jesús Rodríguez	13543916	1978-06-29	noquedanya@gmail.com	Costa Azul	\N	18
127	Jesús Sánchez Méndez	34601872	2012-04-09	mendez.jesus123499@gmail.com	La Playa	vivero_creativo	18
128	Jesús Velázquez	30414703	2003-04-22	serranojesus268@gmail.com	Santa Ana	Chuxx_Hunter	18
129	Jhadiel Manzano	34011505	2011-01-06	iamjhadielmanzano@gmail.com	Puerto Ordaz	jhadielart	6
130	Jhoan Cortesia	27899787	2000-11-30	cortesiajh@hotmail.com	Antolín del Campo	Jhoan_cortesia	18
131	Jhoiler Salazar	\N	2010-12-11	jhoilermisaell1112@gmail.com	El Cercado	\N	18
133	Jhoselyn Mata	26501016	1997-03-27	jhoselyn.mata@gmail.com	Pedro González, Margarita	\N	18
134	Joaquin Ortega	34548614	2012-12-17	liliana_ort@hotmail.com	Santa Cruz de Mora	\N	15
135	Jocelyne Vásquez	25002122	1994-11-10	jocelynvasquez444@gmail.com	Puerto Ordaz	Cienciafilosofialovesong	6
122	Jade López Marcano	34283428	2010-09-25	jadheet13@gmail.com, rufina33mar@gmail.com	La Asunción	krosm0	18
136	Jorge Ender Urbina Sosa	12780556	1977-04-23	enderapius77@gmail.com	Mérida	jorgeenderurbina	15
137	Jorge Santos	\N	2012-07-23	samuelholavillamizar@gmail.com	Playa el Ángel	Aaronsantosbravo223	18
138	José Ángel Rojas Ortiz	33063055	2010-09-14	joseangelrojasortiz@gmail.com	Aricagua	\N	15
139	José Antonio Rojas Ortíz	\N	2007-06-08	azabache002@hotmail.com	Aricagua	\N	15
140	José Bastidas	25777673	1993-07-05	bastidasjose911@gmail.com	Upata	\N	6
141	José Bello	27280029	1999-03-10	j.bellofermin85@gmail.com	La Asunción	jadanart	18
142	José Gregorio Muñoz	33754510	2010-02-05	dionylozada82@gmail.com	Porlamar, Margarita	\N	18
143	José Marcano	8396109	1962-04-23	marymarcanocampos@hotmail.com	La Asunción	\N	18
144	Joselin Williams	27467921	2000-04-25	euphoriaxart@gmail.com	Caracas	euphoriax_art	10
145	Juan Andres Flores Fernandez	24720636	2014-01-18	valentina18fernandez@gmail.com	San Antonio	\N	16
146	Juan Prieto	20137640	1988-01-10	jjpm4875@gmail.com	Upata	\N	6
147	Juan Salvador Muñoz Aponte	17554074	1986-11-01	juansalvador11@gmail.com	Sector San José del Ávila, Caracas	\N	10
148	Juberson Jules	25212606	1993-08-28	jubersonoriol@gmail.com	Caracas, parroquia El Junquito Km 15	jules_oriol	10
149	Karen Sofía Stohr	32751355	2008-09-30	stohrkaren@gmail.com	Caracas	hermanostohr	10
150	Karina Barrios	13609019	1976-05-30	shoppy76desing@gmail.com	El Valle	\N	18
151	Karol Velásquez	31061483	2005-04-11	karol.v.velasquez@gmail.com	San Antonio	\N	16
152	Katherine Solano López	12672968	1973-05-30	kattysolano481@gmail.com	Juan Griego, Margarita	\N	18
153	Keleannys Silva	28435706	2001-03-12	kele.dv.silva.g@gmail.com	Juan Bautista Arismendi	\N	18
154	Kevin Gómez	33646766	2012-09-08	mariarosperezvas13@gmail.com	La Asunción	mariarosaperez43	18
155	Kristi Duarte	32964369	2009-05-03	soniadugarte.18@gmail.com	Santa Cruz de Mora	\N	15
156	Larian Cammarata	29948435	2003-11-25	lariancammarata25@gmail.com	Caracas	blartec	10
157	Laura Guerra	32551280	2007-04-08	08lauale@gmail.com	La Asunción	mi_mundo_de_dibujos	18
158	Lina Andrea Restrepo Henriquez	33379764	2010-06-09	CRISST25@hotmail.com	La Asunción	\N	18
159	Lisbeth María Ordáz Subero	12673088	1976-01-13	lis-ordaz@hotmail.com	Playa El Agua	\N	18
160	Lisbeth Rojas	13966823	1979-02-27	rojaslisbeth87@gmail.com	Mérida	lisbethrojas5	15
161	Lottys Boggiano	26473529	1998-10-15	neoalquemist@gmail.com	Caracas	lottys_98	10
162	Lucia Pernalette	30911544	2005-05-04	lpv0405@gmail.com	La Asunción	\N	18
163	Luis Alberto Lara	10149898	1967-10-16	soyalbertolara@gmail.com	San Cristóbal	obrasdelara	21
164	Luis Andrés Castellano Wer	34084345	2010-02-15	jamynohemi.10@gmail.com	Maracaibo	jamynohemi	24
165	Luís Ascanio	10349239	1970-01-08	luisascaniofficial@gmail.com	Caracas	ascaniosart	10
166	Luis Cardona	29985276	2002-02-21	Direccionpmv@gmail.com	El Espinal	\N	18
167	Luis David Ron Hernández	28166352	2001-08-10	luisdavidron01@gmail.com	La Asunción	\N	18
168	Luis Lezama	24536810	1992-11-14	luislezamadg@gmail.com	Aricagua	\N	15
169	Luis Mata	20326017	1990-03-29	chavalento@gmail.com	Maneiro	\N	18
170	Luis Miguel Cazorla Lugo	33781351	2008-12-29	omokillopez@gmail.com	Villa Rosa	\N	18
171	Luis Montero	24220378	1994-01-09	arquimontero.tallerdedibujo@gmail.com	Caracas	Drawmontero	10
172	Luisa Emilia Bermúdez	3881324	1949-01-22	edecia.marcolina@gmail.com	Caracas	\N	10
173	Luisana Estanga	27424121	1998-07-08	estangaluisana@gmail.com	Porlamar, Margarita	Luisanaestanga	18
174	Luz Estefanía Galán Ibáñez	25977712	1996-08-10	luzgalan1028@gmail.com	Mérida	luzest_art	15
175	Manuela Piccioli	33062690	2009-02-05	marfishca@gmail.com	La Asunción	\N	18
176	María Bermúdez	17289859	1984-08-23	maria19bermudez84@gmail.com	Upata	maria19bermudez84	6
177	María Carolina Brito Díaz	24230900	1994-09-08	mcarl2333@gmail.com	Cardón	\N	11
178	María Elena Gago Sanabria	6928376	1966-07-19	mariaelenagago@gmail.com	Altos de Santa Fe	mariela.gago	16
179	María Elena Lozada	6280581	1969-01-29	mariaelenalozada@gmail.com	Caracas	Mariaeastro	10
180	María Elena Rodríguez	9787783	1969-12-02	marialayet@hotmail.com	Tovar	maria_layet	15
181	María Félix Gutiérrez Pérez	30890448	2004-01-12	mf.gutierrezperez.12@gmail.com	San Cristóbal	\N	21
182	María Laura Restrepo Henriquez	31649240	2007-01-09	CRISST25@hotmail.com	La Asunción	\N	18
183	María Montaño	27100755	1994-02-14	mardearte97@gmail.com	Porlamar, Margarita	mardeart3	18
184	María Pernía	31087903	2004-02-19	m4pernia@gmail.com	Guarenas	emora	16
185	Maria Victoria Milano López	30501265	2004-10-25	marivickymillop20@gmail.com	Puerto Ordaz	mariavictoriamilano_25	6
186	Marialbert Almeida Martinez	29655811	2001-09-29	mar.almeida2909@gmail.com	La rinconada de Paraguachi	Mar.almeida29	18
187	Mariana González	26576340	1998-09-16	marmorena33@gmail.com	Los Robles	\N	18
188	Mariangel Marrero	30783981	2004-12-29	mariangelmv29@gmail.com	Ciudad Bolívar	mariangelmv_	6
189	Mariela Travieso	10758944	1972-02-23	patrocinanteef@live.com	Turmero	\N	4
190	Mariuska Picos Becerra	32764217	2008-12-22	guerreromariilla@gmail.com	San Cristóbal	guerreromariilla	21
191	Marla del Valle Gutiérrez Henríquez	26501959	1999-04-19	marlagutierrezh99@gmail.com	La Guardia	im_garlopa	18
192	Mary Malave Fernandez	24109546	1995-01-26	maryalexandrafernandez95@gmail.com	Conuco Viejo	\N	18
193	Mary Pacheco	30437073	2003-10-09	spom236@gmail.com	Ciudad Guayana	spom236	6
194	Mateo Martínez	28422351	2001-01-11	matmar566@gmail.com	San Cristóbal	\N	21
195	Mayra Alejandra Molina	12779958	1976-10-28	cataleja2001@yahoo.com	Atamo Sur	\N	18
196	Melania Rivas	31256707	2005-11-16	melaniarivas16@gmail.com	Juan Griego, Margarita	\N	18
197	Micaela Serra Mendoza	\N	2010-04-10	kaiserra1@gmail.com	Pampatar	\N	18
198	Miguel Armando Ávila	25807334	1995-10-14	miguelarmandoavro@gmail.com	Porlamar, Margarita	\N	18
199	Miguel Medina	27125657	1999-03-30	miguelmedinalara@gmail.com	Antolín del Campo	arquiguel	18
200	Miguelangel Zapata Morales	25025802	1996-03-16	miguelangelzm166@gmail.com	San Cristóbal	Miguelangel166	21
201	Milagros Domínguez Velásquez	30910824	2004-03-30	milydominguezve3003@gmail.com	(La Vecindad) Municipio Gómez	\N	18
202	Monica Ferreres	6810875	1964-05-04	monic.ferreres@gmail.com	Pampatar	\N	18
203	Nadeska Amaya	18248712	1986-08-31	Amaya.nadeska@gmail.com	Santa Ana	\N	18
204	Nathalia Pereira	32063126	2007-01-22	nathaliapereiramolina9@gmail.com	La Playa	\N	18
205	Nathaly Belen Colmenares	33062242	2008-12-21	LRCOLMENARESB@hotmail.com	Porlamar, Margarita	\N	18
207	Néstor Fernández	\N	2012-03-03	gonzalezy63m@gmail.com	Maracay	yune_milag	4
208	Nicole Labrador	30547537	2003-08-29	nicole.labrador03@gmail.com	La Asunción	itsnixci	18
209	Nicolle Cortina	\N	2011-11-11	deliscc@hotmail.com	Porlamar, Margarita	\N	18
210	Noel Hernández	29864027	2003-06-03	noel78945@gmail.com	Pampatar	noelferrer_18	18
211	Nohelly Ramos	\N	2010-12-03	nohe.santi0330@gmail.com	La Vecindad	\N	18
212	Noredni Mata Blanco	33857990	2011-09-01	noremabl@gmail.com	Maneiro	\N	18
213	Olegario Daniel Moya Caraballo	11146988	1971-09-26	daniemoyacaraballo@gmail.com	Paraguachí	\N	18
214	Oliver Mathias Ramirez Gonzalez	\N	2014-12-26	gomezmariaw26@gmail.com	San Diego	\N	7
215	Oriana Jibely Mejía Bautista	27504086	1998-08-13	jibelymejia@gmail.com	Ciudad Guayana	jibelysart	6
216	Oriana Sanchez	32404478	2007-11-22	rvegas905@gmail.com	Valencia	vegasroxa	7
217	Osiris Moreno Carrizales	4852569	1959-01-30	osirismoreno569@gmail.com	Caracas	morenitas12	10
218	Paola Landa	30464090	2004-08-24	Paolavlandaa@gmail.com	Villa de Cura	Landa_pcartoonist	4
219	Paola Martín	\N	2008-08-21	paolamartinacevedo@gmail.com	Caracas	\N	10
220	Pedro Javier Diaz Marquez	15897877	1981-05-18	redesam010203@gmail.com	Carabobo	cochepart	7
221	Pedro Luis Monsalve	29947727	2003-03-14	pedroluismonsalved@gmail.com	Caracas	calidoch	10
222	Priscila Medori Castro	31648765	2006-08-23	priscilamedori@gmail.com	Paraguachí	\N	18
223	Raquel Torres Sbrollini	7079207	1962-09-13	nuestroarte2021@gmail.com	Valencia	\N	7
224	Rayger David Hernández Rodríguez	30230472	2004-03-15	rayger24@gmail.com	Porlamar, Margarita	tejidos m.a8	18
225	Rebeca Morales	18855433	1990-01-08	rebecamoralesvitas90@gmail.com	Palo Negro	poesia_714	4
226	Rebeca Salas	20748088	1994-01-09	rebeca.s.c94@gmail.com	Playa el Ángel	\N	18
227	Rebecca Nahon	31649672	2007-04-25	rebeccanahon143@gmail.com	Porlamar, Margarita	\N	18
228	Rebecca Soler Levy	31821206	2006-01-06	soler12306@gmail.com	Pampatar	r.soler_art	18
229	Ricardo Millán	23592478	1995-09-09	millanr09@gmail.com	San Juan, Margarita	rmillang	18
230	Ricmar Hidalgo	28629780	2002-04-22	ricmarhidalgo@gmail.com	La Asunción	ricmar_green	18
231	Roberto Gualtieri	31460174	2006-02-18	legoman18022006@gmail.com	Caracas	cobramineratv	10
232	Rodrigo Guzmán	\N	2008-02-19	valentinapico@gmail.com	Porlamar, Margarita	\N	18
233	Roger Andrés Rodriugez Parra	33411552	2010-01-22	rogerandresrodriguezparra6@gmail.com	La Playa	vivero_creativo	18
234	Rosanny Andrea Flores Marquez	\N	2014-03-21	roselena0306@gmail.com	Mérida	\N	15
235	Rosario Salazar Bravo	6483680	1962-11-22	salazarbravo@gmail.com	Caracas	\N	10
236	Rubén Darío Pozanco Guzmán	33042254	2009-11-09	catheguzman@hotmail.com	Pampatar	\N	18
237	Rubén Josué Méndez Dugarte	25720015	1996-01-04	rubenmendezduarte@gmail.com	Santa Cruz de Mora	Rubenmendez_art	15
239	Ruth Guzmán	20904750	1992-07-06	alkimista_sparkis@hotmail.com	Porlamar, Margarita	\N	18
240	Ruth Mendoza	25678692	1994-01-10	a1d2ry@gmail.com	Upata	\N	6
241	Sabrina Ramirez	30750111	2005-05-04	sabrinaramirez30750@gmail.com	Porlamar, Margarita	\N	18
242	Salvador Ruiz	33841391	2010-02-13	salvadoralejandroruiz2010@gmail.com	Maturín	Salvador_draw	17
243	Samanta Flores	33105310	2009-10-04	milestilesprower@gmail.com	Maracaibo	Samylu_Flores	24
244	Samantha Atenea Dávila Rojas	33576187	2010-09-12	rojaslisbeth87@gmail.com	Mérida	samantha12atenea	15
245	Samantha Desmedt	30277838	2003-07-27	samadesmedt@gmail.com	Pedro González, Margarita	\N	18
246	Samantha Gascón	32896971	2009-09-09	samy.gasconm@gmail.com	Caracas	\N	10
247	Samuel Almau	34647352	2010-03-25	samuelalmau@gmail.com	Paraguachí	\N	18
248	Samuel David Osorio Ruesta	31821178	2007-08-31	susanruestaosorio@gmail.com	Costa Azul	\N	18
249	Samuel González	32051159	2007-07-17	samueligc17@gmail.com	Paraguachí	\N	18
250	Samuel Villamizar	29582024	1999-01-18	samuelholavillamizar@gmail.com	Los Robles	Samuelholavillamizar	18
251	Sandra Lucia Jiménez Sandoval	32475552	2008-01-12	edujido@gmail.com	El Cercado	sandra_artist01	18
252	Santiago Jose Girón Ortega	32571307	2007-07-19	arjoordi@gmail.com	Barcelona	artsantg	2
253	Saribet Peralta	30627644	2004-04-02	Saribetperalta@gmail.com	Tucupido	SaribetPeralta	12
254	Sebastián Murachi Molina Márquez	33910679	2008-06-05	rmtallerdearte@gmail.com	Santa Cruz de Mora	rm_taller_de_arte	15
255	Selena Vicent	27650800	2001-02-01	selenavicent1r@gmail.com	La Asunción	selenavicent	18
256	Sharick Nicolle López Sequera	30870098	2005-05-17	sharicklaprincesa@gmail.com	El Valle del Espíritu Santo	\N	18
257	Sofia Fornerino	32607449	2008-08-01	sofiamargaritafs@hotmail.com	Caracas	norai_fg	10
258	Sonia García	18665676	1988-11-18	Soniargi.arq@gmail.com	Puerto La Cruz	Sgi.graphics	2
259	Susan Angela Ruesta de Osorio	24444323	1976-07-01	susanruestadeosorio@gmail.com	Costa Azul	\N	18
260	Susan Ester Osorio Ruesta	31420916	2006-07-06	susanruestaosorio@gmail.com	Costa Azul	\N	18
261	Susana Camila Martínez Urbáez	27870894	2001-04-15	scamilamartinezu@hotmail.com	Porlamar, Margarita	\N	18
262	Tibaldo Rios	16217880	1984-02-06	tibaldorios@gmail.com	Valencia	tibaldorios	7
264	Valentina Rojas	31228094	2006-04-12	valentinarojas73839@gmail.com	Costa Azul	\N	18
265	Valentina Urdaneta	13114413	1976-09-10	valentina.urdaneta@iesa.edu.ve	El Hatillo	\N	16
266	Valentina Victoria Chaparro	\N	2011-05-21	enith.inmobiliaria@gmail.com	Porlamar, Margarita	paceducarte	18
267	Valeria Castro	33328785	2010-09-13	sterlina.nc@gmail.com	San Antonio de los Altos	\N	16
268	Valeria Gutierrez	30283760	2004-09-19	vdvgg2004@gmail.com	Pampatar	\N	18
270	Valeria Muchati	33957579	2010-10-17	antonio8209@hotmail.com	Porlamar, Margarita	paceducarte	18
271	Valeria Saraí Rodríguez Durán	\N	2011-03-10	greydaduran@gmail.com	Juan Griego, Margarita	\N	18
272	Valeria Torres	31663515	2006-10-12	valeriatorrespirela@gmail.com	Barquisimeto	\N	14
238	Russell Labrador	34175110	2008-03-17	lesliedannedys@gmail.com, russ178890@gmail.com	La Asunción	surrealistshadow	18
269	Valeria Isabel Cazorla	34037029	2011-07-07	valentinalandaeta@gmail.com, valavatherapy@gmail.com	Isla de Margarita	\N	18
273	Valeria Witzke Darwich	29887458	2003-03-17	chiquiloolee@gmail.com	Caracas	neverendingedge17	10
274	Veronica Agreda	30209174	2003-09-09	99veroagreda@gmail.com	Cotoperiz, Margarita	veroart99	18
275	Victor Eloy Figueroa Rojas	9428819	1968-06-17	victoreloyfigueroa@gmail.com	Porlamar, Margarita	victor.figueroa.5099940	18
276	Victoria Contreras	32564109	2008-11-04	ngomezipc@gmail.com	Caracas	\N	10
277	Victoria Elizareth Gutiérrez Contreras	\N	2014-04-21	rmtallerdearte@gmail.com	Santa Cruz de Mora	rm_taller_de_arte	15
278	Victoria Marquina	27995822	2000-10-04	Vicvicmarquina@gmail.com	Caracas	Itsvikitoria	10
279	Victoria Ysabella Urbina Peña	30270250	2004-04-23	vikitollaurbina@gmail.com	Mérida	hidden_ink_demon	15
280	Wilmar Gallardo	25514611	1996-10-30	wilmar_3010@hotmail.com	Caracas	betzartist	10
281	Wilmer Alejandro Zabala	21324523	1993-05-12	wilmeralejan@gmail.com	Porlamar, Margarita	\N	18
282	Yaleska Alba	30884738	2004-04-05	albayaleska53@gmail.com	Upata	\N	6
283	Yaskely Sánchez	26939918	1982-08-06	bastidasjose911@gmail.com	Upata	\N	6
284	Yasmin Mayrena Alviarez Gauta	26068036	1997-11-09	mayrena.gauta09@gmail.com	San Cristóbal	\N	21
285	Yeimar Ruiz	32032076	2004-04-08	eliubermudez8@gmail.com	Upata	\N	6
286	Yenireth Del Valle Vasquez Oliveros	21322776	1992-12-02	yenvasquezoliveros@gmail.com	Guatamare - La Comarca	\N	18
287	Yessika Yosneidy Contreras Márquez	32144061	2007-08-05	rmtallerdearte@gmail.com	Santa Cruz de Mora	rm_taller_de_arte	15
288	Yesymar Lanza	31985968	2007-03-09	yesymarlanz@gmail.com	Barcelona	yesyocean	2
289	Yihsi Berenice Cano Peña	13978974	1978-12-04	yihsicano@gmail.com	Chacao	\N	16
290	Ynayad Luque	30518388	2003-05-08	luqueynayad@gmail.com	Urachiche	Ynachu083	23
292	Yohanna Yañez	15931981	1982-02-25	yoya.artesanias@gmail.com	Porlamar, Margarita	\N	18
293	Yudianalit Martinez	33507367	2008-06-09	fyanniset@gmail.com	Upata	\N	6
294	Yulianngy Rodríguez	29655130	2002-12-10	Yulianngydelvrm.ydvrm@gmail.com	La Asunción	yuliarty_1012	18
295	Yurenny Oliveros	20538983	1993-02-23	yure20oliveros@gmail.com	La Vecindad, Margarita	yuree.ilustra	18
296	Zena El Souki	17199730	1985-12-14	zenasouki@gmail.com	Maracay	zanzun_art	4
298	Zoe Frances	32495199	2008-04-04	iriandreinag@hotmail.com	Pampatar	\N	18
300	Zoraida Torrado	1094574867	1988-12-06	zorita.torrado@gmail.com	Upata	\N	6
301	Zulay Castañeda	4177553	1955-03-01	zulcast@gmail.com	San Juan Bautista	\N	18
302	Zuleima Decán de Rivadeneira	7660013	1963-04-29	zuleima.decan@gmail.com	Mérida	zuleima_rivadeneira	15
35	Antonio Istillarte	12094158	1975-03-19	lapizviajero2013@gmail.com	Caracas	722lapizviajero	10
132	Jhonneiker Zerpa	28316299	2001-11-14	j.neikersupremo@gmail.com	El Valle, Isla de Margarita	jneikerarte	18
297	Zoe Antonella Miranda Díaz	34340326	2011-02-21	zoemirandad2@gmail.com, miranda.l.robert@gmail.com	Porlamar, Margarita	zoemir45	18
50	Charlotte Arts Reyes	32051119	2007-07-03	kidscreativesouls@gmail.com, charlaarte@gmail.com	Porlamar, Margarita	charlaarte	18
291	Yohana Murgas	20676537	1991-06-24	tamara_murgas@outlook.com, yohanamurgas91@gmail.com	Porlamar, Margarita	\N	18
369	Hirama Moreno	5891185	1960-12-30	mitamoreno12@gmail.com	Libertador	\N	10
370	Yorbelis Guedez	25773609	1992-04-12	sara7guedez@gmail.com	Libertador	\N	10
371	María Silvia Tomillo	10817871	1977-11-16	mariasilviato@gmail.com	Libertador	\N	10
372	Igsy Mijares Ibarra	6902369	1965-02-25	proyectosmedios20@gmail.com	Libertador	\N	10
373	Marianella Castro Mata	11739057	1975-10-13	mcm.ideas@gmail.com	El Hatillo	\N	10
374	María Jacquelin Pérez	6523137	1960-09-30	maria60perez@gmail.com	Libertador	\N	10
375	Esteban Ramírez	16334582	1985-02-13	estebanramirez085@gmail.com	Sucre	\N	10
376	Guerri Jesús Mota Cantor	6191622	1966-12-18	Garymota18@gmail.com	Santa rosalia	\N	10
377	Esperanza Rodríguez	6853059	1963-07-04	esperanzarodrigues1963@gmail.com	Libertador	\N	10
378	Elena Ferrera	10378908	1969-10-24	elenaelizabethf@gmail.com	LIBERTADOR	\N	10
379	Sina Aysel Gonzalez Ferrera	34382830	2011-12-01	sinaigon41@gmail.com	LIBERTADOR	\N	10
380	Dhana Velásquez	26908385	1999-07-15	dhanavelasquez@gmail.com	Baruta	\N	10
381	Marbelia Linares	5099380	1959-11-21	linaresmarbelia80@gmail.com	Urdaneta	\N	10
382	Jerry Delgado	24773404	1995-05-08	jerrysdwagg@gmail.com	Libertador	\N	10
384	Jenny Israelabreu	10800483	1981-07-08	pulgin2022@gmail.com	Miranda	\N	10
385	Andrea Montrone	27916773	2000-09-08	montroneabreu@gmail.com	El hatillo	\N	10
386	Jose Antonio Alvarez Celis	17123073	1985-06-24	jalvarezcelis@gmail.com	Sucre	\N	10
387	Franco Calomino	20132043	1992-01-13	francocalomino13@gmail.com	Libertador	\N	10
388	Carolina Abreu	6317463	2025-07-18	cabreu1807@gmail.com	Hatillo	\N	10
389	Keyler Navas	25546958	1997-02-01	Bastkeyler@gmail.com	Libertador	\N	10
390	Carlos Carmona	27283500	1999-07-31	cce31.07@gmail.com	Baruta	\N	10
391	Douglas Gatters	5279325	1956-08-28	douglasgatters@gmail.com	Cristóbal Rojas	\N	10
392	Diego Ortega	20365898	1992-05-27	diegominakowski@gmail.com	Baruta	\N	10
393	Bethsayda Cabrera	17532713	1986-05-08	bethcabreram@gmail.com	Distrito Capital	\N	10
394	Yosef Colonia	25258683	1996-03-22	Chichecolon1996@gmail.com	Libertador	\N	10
395	Inti Garboza	16591692	1983-06-18	igarboza@gmail.com	Libertador	\N	10
396	Luis Rafael Martínez	5532011	1960-07-03	lrmartinez@gmail.com	Santa Teresa, Caracas	\N	10
397	Alejandro Campero	16599560	1985-04-03	Acampero30@gmail.com	Sucee	\N	10
398	Jesús Rangel	4315645	2010-01-01	Jesús.rangel04@gmail.com	La pastora, Caracas	\N	10
399	Karina Stohr	10795884	2010-01-01	fundacion.carlos.stohr@gmail.com	La pastora, Caracas	\N	10
400	Leonardo Aguilera	11412566	2010-01-01	leo.dmyc@gmail.com	La pastora, Caracas	\N	10
401	Mary Aponte	12749729	2010-01-01	rosethsardinha@gmail.com	La pastora, Caracas	\N	10
402	Paula De De Ituarte	\N	2010-01-01	fdi853372@gmail.com	La pastora, Caracas	\N	10
403	Antonella Velázquez	\N	2010-01-01	taller_3_8480@fundacionstohr.org	La Pastora	\N	10
404	Antonella Chacon	\N	2017-01-26	egabriela1703@gmail.com	Libertador	\N	10
405	Ariensi Aristimuño	\N	2010-01-01	taller_5_8489@fundacionstohr.org	La Pastora	\N	10
406	Carol Quintero	\N	2010-01-01	taller_6_8492@fundacionstohr.org	La Pastora	\N	10
407	Dana Ramo	\N	2010-01-01	taller_7_8495@fundacionstohr.org	La Pastora	\N	10
408	Dylan Peña	\N	2017-12-01	angiekboada@gmail.com	Libertador	\N	10
409	Eva Márquez	\N	2010-01-01	taller_9_8502@fundacionstohr.org	La Pastora	\N	10
410	Lucía Hernández	\N	2010-01-01	taller_10_8505@fundacionstohr.org	La Pastora	\N	10
411	Maria Clemencia Gómez	\N	2018-05-29	sabinaesther84@gmail.com	Libertador	\N	10
412	Paula Caraballo	\N	2017-09-16	natyporras17@gmail.com	Vargas	\N	10
413	Wilangel Ávila	21090683	2017-02-11	home24avilabr.mmonsalve@gmail.com	El Valle	\N	10
414	Ariadna Malpica	34869458	2013-07-30	elsibeth30@gmail.com	Libertador	\N	10
415	Joseline Landaez	34277291	2012-02-03	cerezas.green@gmail.com	Libertador	\N	10
416	Kamila Sánchez	34630986	2013-02-21	inlm31@gmail.com	Libertador	\N	10
417	Ristal Castro	36135127	2014-01-08	gonzalez0108max@gmail.com	San José cotiza	\N	10
418	Letizia Araque	33625356	2010-12-24	legna.araque@gmail.com	Libertador	\N	10
419	María José Mejias	36364352	2013-05-04	greciaacosta@gmail.com	Libertador	\N	10
420	Mathias Alejandro Zamora González	36034343	2011-01-12	rosielgf@gmail.com	Libertador	\N	10
421	Ruben Duarte	\N	2010-01-01	taller_29_8555@fundacionstohr.org	La Pastora	\N	10
422	Sebastián Vázquez	34080374	2011-10-02	josevazques79@gmail.com	Libertador	\N	10
423	Sophia Simoes	\N	2010-01-01	taller_31_8563@fundacionstohr.org	La Pastora	\N	10
424	Andrea Cruz	26476982	1998-04-21	andreacruzyanes@gmail.com	Libertador	\N	10
425	Anyullieth Reyes	30497105	2004-08-18	reyesanyullieth@gmail.com	Libertador	\N	10
426	Brianna Valecillos	32537122	2006-01-12	valecillosbrianna1201@gmail.com	Sucre	\N	10
427	Diossany Almeda	30062474	2002-10-11	dyolo3012@gmail.com	sucre	\N	10
428	Donis Álvarez	31123316	2005-11-18	donisalejandro18@gmail.com	Libertador	\N	10
429	Fabiola Tineo	29969143	2002-06-05	fabitineomoreno@gmail.com	Libertador	\N	10
430	Gabriela Godoy	32887110	2008-10-28	mtoro1041@gmail.com	Libertador	\N	10
431	Maria Moron	29871957	2002-11-12	valen1112002@gmail.com	libertador	\N	10
432	Marian Lugo	29720309	2000-08-10	marianclugoa@gmail.com	Libertador	\N	10
433	Michelle Narváez	29832082	2002-03-25	michesnal@gmail.com	Zamora - Guatire	\N	10
434	Oscar Soto	19868333	1989-07-11	sol.dollmaster@gmail.com	Libertador	\N	10
435	Shelsea Hernández	31518326	2005-10-20	hernandezshells2005@gmail.com	Libertador	\N	10
436	Siddhy Álvarez	25957568	1997-07-10	siddhyalvarez@gmail.com	Sucre	\N	10
437	Sofía Rodríguez	28318384	2002-10-15	sofiacamilacollage@gmail.com	Sucre	\N	10
438	Solimar Herrera	19868691	1992-08-22	artedigital.sh@gmail.com	Libertador	\N	10
439	Valentina Herrera	31399721	2006-02-20	Valentinaherrera.unearte@gmail.com	Libertador	\N	10
440	Victor Emilio Mejia	33654456	2010-10-25	evelynmartinez501@gmail.com	Libertador	\N	10
441	Moraima Palma	5567319	1960-08-17	morapalma1760@gmail.com	Sucre	\N	10
442	Nailah García	34298242	2012-02-03	betzabethsalinas49@gmail.com	La pastora	\N	10
443	Nicole Abbondanza	32528885	2008-05-23	nicoleval2008@gmail.com	Dtto Capital	\N	10
444	Adrián Acosta	28143780	2001-09-17	adrimoiacosta@gmail.com	Libertador	\N	10
445	Andrea Torres	27795774	2000-05-11	soyandyt@gmail.com	Libertador	\N	10
446	Beiker Burke	30045416	2001-12-26	bezbuzg@gmail.com	Zamora	\N	10
447	Chantal González	30513039	2004-10-10	gonzalezchantal853@gmail.com	Libertador	\N	10
448	Eliomar Mendoza	22381306	1994-04-03	eliomendoza17@gmail.com	plaza	\N	10
449	Emily Hidalgo	30821406	2006-09-05	emilyhd308@gmail.com	Libertador	\N	10
450	José Luis Mejias Buitrago	11195826	1972-08-26	jluismejias@gmail.com	Libertador	\N	10
451	Josept Villamizar	19966627	2025-07-26	joseptvillamizar@gmail.com	libertador	\N	10
452	Keyra C Gonzalez Duran	32856851	2009-05-03	heyocar@gmail.com	Sucre	\N	10
453	Maria José Ramírez	26868687	1997-07-06	mariajoseramirez.art@gmail.com	Libertador	\N	10
454	Moisés Picot	29990427	2002-07-18	moisespicot2121@gmail.com	Libertador	\N	10
455	Ginia Fransheska Pérez	34162765	2012-03-26	calderinvirginia977@gmail.com	Guacuco municipio arismendi	@giniaca	18
456	Naygreg Herrera	34224564	2011-10-28	cdgv2021@gmail.com	Juan Griego	\N	18
457	Melissa Abad	34581689	2013-01-24	melissaabad2301@gmail.com	La Asunción	Soy_valen_oficial	18
458	Manuela Espin	36296236	2014-10-23	anamquijadar@gmail.com	La Asunción	anitamayre	18
459	Diego González	36295696	2013-09-18	dgonri2013@gmail.com	Santa Ana	\N	18
460	Santiago Hernàndez	\N	2016-02-17	abg.m.amundaray@gmail.com	Porlamar	\N	18
461	Valentina Pérez	31056486	2005-10-06	valentinanaomi.05@gmail.com	La Guardia, guarida del sol	@vael.ae	18
462	Jan Velásquez	31061565	2005-09-09	janvt65@gmail.com	Playa el Angel	\N	18
463	Ender Ydrogo	31062261	2005-02-23	ydrogoenderj@gmail.com	Porlamar	e.ydrogo	18
464	Alejandra Villarroel	30685626	2004-05-18	avillarroellanda18@gmail.com	Juangriego	artleeav	18
465	Litzi Andreina Romero	32495577	2008-08-22	gromero412@gmail.com	Punta de Piedras	Hydrawolf_0009	18
466	Angélica María Franco	33957150	2010-03-23	romeroguiseppe@gmail.com	Punta de Piedras	angelit123456xp	18
467	Frangelymar Moyano	30408295	2004-06-25	frangelymarm@gmail.com	La Blanquilla, Tubores	@franzart2506	18
468	Gabriela González	33136721	2008-01-01	ci33136721@fundacionstohr.org	Tacarigua	\N	18
469	Jesús Aristiguieta	29582397	2002-05-22	mogekozx@gmail.com	Jorge Coll	\N	18
470	María Figueroa	27525142	1999-12-27	Mariafigueroamijares@gmail.com	Los robles	figuroamaria	18
471	Cruz Miguel Prieto	5480048	1959-09-16	cruzpintura@gmail.com	La Asunción	@Cruzprieto	18
472	Natasha Santaella	16249618	1979-09-28	santaellanathacha@gmail.com	La Asuncion	\N	18
473	Mayerlinamundaray	12921792	1975-11-20	abg.m.amundaray@gmail.com	Porlamar	\N	18
331	Carlos Stohr	\N	1931-09-29	no-especificado@fundacionstohr.org	La Asunción	\N	18
359	Maximiliano González Citterio	10337545	1969-12-24	magocitt@gmail.com	Baruta	\N	10
333	Susana González	\N	1000-01-01	no-especificado@fundacionstohr.org	Pampatar	\N	18
334	Fredy Fernández	\N	1000-01-01	no-especificado@fundacionstohr.org	Pampatar	\N	18
366	Andres Romero	\N	1000-01-01	agraffico@gmail.com	Santa ana	\N	18
367	José Ignacio Maurera	\N	1000-01-01	joseignaciomaurera@gmail.com	Achipano, Porlamar	\N	18
368	Valentina Hernandez	\N	1000-01-01	angelysvsj@hotmail.com	Villa juana	\N	18
355	César Agudelo	22001980	1000-01-01	cesar8006@gmail.com	Caracas	\N	10
356	Federico De Ituarte	5003178	1000-01-01	fdi853372@gmail.com	Caracas	\N	10
357	Luis Julio Toro	\N	1000-01-01	no-especificado@fundacionstohr.org	Caracas	\N	10
358	María Teresa Novoa	3751006	1000-01-01	mtnovoac@gmail.com	Caracas	\N	10
360	Yil Baüer	\N	1000-01-01	yilcbauer@gmail.com	Caracas	\N	10
362	Daniela Guglielmetti	\N	1000-01-01	no-especificado@fundacionstohr.org	Caracas	\N	10
363	Edurado González	7229487	1000-01-01	pintured@gmail.com	Caracas	\N	10
\.


--
-- Data for Name: t_p; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.t_p (id, taller_id, participante_id) FROM stdin;
1	1	44
2	1	50
3	1	51
4	1	79
5	1	81
6	1	97
7	1	108
8	1	110
9	1	191
10	1	202
11	1	228
12	1	247
13	1	251
14	1	294
15	1	295
17	2	1
18	2	20
19	2	51
20	2	62
21	2	65
22	2	92
23	2	119
24	2	130
25	2	132
26	2	183
27	2	191
28	2	213
29	2	251
30	2	274
31	2	294
32	2	295
33	3	4
34	3	31
35	3	32
36	3	94
37	3	208
38	3	212
39	3	238
40	3	251
42	4	1
43	4	35
44	4	49
45	4	66
46	4	80
47	4	99
48	4	102
49	4	105
50	4	111
51	4	150
52	4	161
53	4	172
54	4	231
55	4	257
56	5	22
57	5	27
58	5	89
59	5	93
60	5	109
61	5	127
62	5	134
63	5	155
64	5	204
65	5	233
66	5	234
67	5	254
68	5	277
69	5	287
16	1	297
41	3	297
70	34	403
71	34	404
72	34	405
73	34	406
74	34	407
75	34	408
76	34	409
77	34	410
78	34	411
79	34	412
80	34	413
81	34	414
82	34	105
83	34	138
84	34	415
85	34	416
86	34	417
87	34	418
88	34	419
89	34	420
90	34	421
91	34	422
92	34	423
93	35	424
94	35	425
95	35	426
96	35	427
97	35	428
98	35	375
99	35	429
100	35	430
101	35	150
102	35	400
103	35	431
104	35	432
105	35	401
106	35	433
107	35	434
108	35	435
109	35	436
110	35	437
111	35	438
112	35	439
113	35	440
114	35	441
115	35	442
116	35	443
117	35	231
118	35	444
119	35	445
120	35	446
121	35	447
122	35	380
123	35	448
124	35	449
125	35	102
126	35	450
127	35	144
128	35	451
129	35	149
130	35	389
131	35	452
132	35	374
133	35	453
134	35	454
135	35	370
\.


--
-- Data for Name: taller; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.taller (id_taller, nombre, fecha, lugar) FROM stdin;
1	Taller conociendo el arte del SUMI-E	2024-08-30	Isla de Margarita
2	Taller de pastel al óleo	2021-09-04	Isla de Margarita
3	Taller Perspectiva en el Dibujo	2021-11-05	Isla de Margarita
4	Taller Sumie	2024-11-02	Caracas
5	Taller Sumie	2024-12-28	Mérida
34	Taller USK Caracas	2026-04-08	Caracas
35	Taller USK Caracas	2026-11-08	Caracas
\.


--
-- Data for Name: telefono; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.telefono (id_telefono, numero_telefonico, participante_id) FROM stdin;
1	0416-0966589	1
2	0424-8651593	2
3	0424-9277178	3
4	0426-5652633	4
5	0412-3545699	5
6	0416-7277257	6
7	0412-1564198	7
8	0424-8977091	8
9	0414-8447466	9
10	0426-1887857	10
11	0414-5268179	11
12	0424-8742917	12
13	0424-7965388	12
14	0424-8564635	13
15	0414-0891595	14
16	0414-0813121	15
17	0414-7926527	16
18	0412-3375451	17
19	0414-2483205	18
20	0412-9638487	19
21	0412-5305218	20
22	0412-9505228	21
23	0426-2234993	22
24	0424-8686305	23
25	0412-0686114	24
26	0424-3777065	25
27	0412-1083702	26
28	0412-6544973	27
29	0424-3783284	28
30	0424-8792161	29
31	0426-4872426	30
32	0416-7986314	31
33	0416-3266437	32
34	0412-1833760	33
35	0412-8685204	34
36	0424-1971493	35
37	0416-6020189	36
38	0414-7335219	37
39	0426-9866724	38
41	0412-3549591	40
42	0424-3127943	41
43	0243-2320574	41
44	0424-4398309	42
45	0412-5739280	43
47	0424-6390184	45
48	0414-9743402	46
49	0295-2423206	47
50	0414-6358886	48
51	0414-4798326	49
53	0412-1912520	51
54	0424-8070096	52
56	0414-0863549	54
57	0412-1115154	55
59	0412-4898954	57
60	0426-2755937	58
61	0412-8603240	59
62	0414-8447466	60
63	0414-7950473	61
64	0424-8742917	62
65	0414-7581315	63
66	0414-7933135	64
67	0426-8379841	65
69	0424-8304650	67
70	0426-2588070	68
71	0414-4517847	69
72	0416-1958213	70
73	0412-3573906	71
74	0414-8811116	72
75	0424-8151289	73
76	0424-1637376	74
77	0416-2962311	75
79	0412-4946869	77
80	0426-4371631	78
82	0412-0172134	80
83	0426-7892030	81
84	0414-8746932	82
85	0412-6483238	83
86	0414-7988223	84
87	0412-0130075	85
89	0424-8719246	87
90	0416-6745093	88
91	0424-7038728	89
92	0412-2920210	90
93	0414-8030791	91
95	0416-1727175	93
96	0412-6738346	94
97	0426-5872088	95
98	0414-7977397	96
100	0426-2274586	98
101	0414-7876274	99
102	0416-3855574	100
103	0414-8155149	101
105	0414-7936886	103
107	0412-2650862	105
108	0412-0961550	106
109	0416-8960650	107
110	0412-3538822	108
111	0424-7038728	109
112	0412-3949154	110
114	0412-3538822	112
115	0412-7380879	113
116	0414-7138930	114
117	0414-4091972	115
118	0424-1756938	116
119	0414-0931142	117
120	0414-9175111	118
122	0414-7741401	120
125	0412-1050403	123
126	0416-1173161	124
127	0414-2493378	125
128	0414-3659915	126
129	0424-7064956	127
130	0416-0316854	128
131	0412-1179792	129
132	0412-0955139	130
133	0424-8190596	131
134	0416-2955248	132
135	0424-8362490	133
136	0416-8789450	134
137	0414-7623105	135
138	0416-3700793	136
139	0412-3533775	137
140	0414-8200276	138
141	0424-8379125	139
142	0416-5850599	140
143	0412-3584966	141
144	0412-1832889	142
145	0426-8878676	143
147	0412-1119712	145
148	0416-1010001	146
149	0212-8623891	147
150	0424-2568532	147
151	0424-1935552	147
152	0424-2673013	148
154	0212-6722185	150
155	0412-3541303	151
157	0412-1875239	153
113	04142762351	111
146	04167036434	144
153	04126100305	149
40	04147892578	39
78	04248931062	76
52	04127943077	50
55	04123527950	53
46	04120961889	44
124	04129261270	122
99	04248463528	97
94	04121912520	92
88	04267897497	86
58	04120443598	56
81	04248994569	79
106	04140982237	104
121	04122051757	119
156	04125461995	152
158	0414-1934163	154
159	0414-0360255	155
160	0424-2404531	156
162	0414-7872288	158
163	0412-0959710	159
164	0412-1063449	160
166	0424-8610969	162
167	0412-1004582	163
168	0424-2096372	164
169	0412-6020914	165
170	0424-8608990	166
171	0295-2422516	167
172	0414-8034105	168
173	0424-8235998	169
174	0424-8724048	170
175	0414-2987083	171
177	0414-8264931	173
178	0412-0793704	174
179	0414-5631777	175
180	0424-9017346	176
181	0414-7959631	177
182	0416-3185271	178
183	0424-1000000	179
184	0414-0693756	180
185	0414-7428886	181
186	0414-7872288	182
187	0424-8083621	183
188	0424-1839085	184
189	0412-8781641	185
191	0412-2295097	187
192	0416-3686079	188
193	0424-3777065	189
194	0412-0686114	190
195	0414-1508160	190
197	0412-1938945	192
198	0412-4752689	193
199	0414-9777128	194
200	0416-6953536	195
201	0414-7481035	195
202	0424-8314334	196
203	0414-7891130	197
204	0412-0950258	198
205	0424-8608430	199
206	0414-7504083	200
208	0414-7976710	202
209	0412-1967778	203
210	0424-7516404	204
211	0412-2952959	205
213	0412-6976756	207
214	0416-0688200	208
215	0412-0960358	209
216	0424-8224827	210
217	0414-4437553	211
218	0416-8966085	212
219	0416-8950733	213
220	0414-4114812	214
221	0426-6954078	215
222	0424-4430125	216
224	0414-4710155	218
225	0414-1387777	219
226	0424-4542319	220
227	0414-2359643	221
228	0416-8953878	222
229	0414-9489474	223
230	0426-1870424	224
231	0412-4656737	225
232	0414-1264049	226
233	0412-3562504	227
234	0416-6951433	227
236	0412-3515023	229
237	0412-1784580	230
238	0416-3049084	231
239	0412-3543868	232
240	0414-7422095	233
241	0414-9163184	234
242	0414-3375675	235
243	0414-0833516	236
244	0424-7090003	237
246	0426-8881389	239
247	0424-9277178	240
248	0412-1886503	241
249	0424-9436001	242
250	0412-6882733	243
251	0412-1063449	244
252	0412-7958677	245
253	0412-6202838	246
255	0412-6483238	248
256	0412-3596207	249
257	0412-0589877	250
258	0424-8014956	251
259	0424-8943429	252
260	0412-3529511	253
261	0414-7584604	254
262	0426-1861099	255
263	0414-8808422	256
264	0426-3007595	257
265	0424-8043389	258
266	0412-6483238	259
267	0412-6483238	260
268	0424-8731523	261
269	0414-5852489	262
271	0424-2114352	264
272	0414-0270012	265
273	0412-3584405	266
274	0412-0874093	267
275	0426-3877424	268
277	0416-9438694	270
278	0412-4971934	271
279	0426-8525560	272
280	0424-1821547	273
281	0412-3528617	274
282	0424-8970567	275
283	0424-1286236	276
284	0412-0729622	277
285	0424-1325796	278
286	0416-5772571	279
287	0424-1698770	280
288	0426-2873450	281
289	0295-2915802	281
290	0424-4411531	282
291	0424-9285421	283
292	0426-8741328	284
293	0424-2130540	285
294	0426-0869448	286
295	573009066592	287
296	0424-2986791	288
297	0416-3049084	289
298	0412-0510537	290
300	0426-3871449	292
301	0424-4411531	293
303	0424-8321795	295
304	0424-3244335	296
305	0416-0325790	297
306	0416-6956855	298
308	0416-5927104	300
309	0414-8009589	301
310	0412-2129713	302
311	4120959550	168
312	4167986314	208
313	4161989228	119
314	4120924884	51
223	04120320000	217
176	04129780190	172
165	04265201574	161
276	04147889093	269
235	04125985072	228
254	04160119405	247
161	04123677461	157
245	04248632205	238
207	04125818356	201
302	04127956463	294
196	04120962656	191
190	04121369023	186
299	04141845993	291
315	4269885111	20
316	4120924884	92
317	4266867902	294
318	4261277041	295
319	0426887759004269107497	177
307	0424-8541070	297
320	4121118933	62
323	4125305218	92
328	4121368782	59
330	04248084093	81
331	04127283433	128
332	04123595587	78
333	04123501964	255
334	04266861221	366
335	04248473395	367
336	04123538191	368
337	04142850590	369
338	04241698880	370
339	04168115913	371
340	04242770363	372
341	04143204044	373
342	04166048024	374
343	04122689865	375
344	04142364865	376
345	04268862178	377
346	04262877422	378
347	04126006807	379
348	04125813263	380
349	04144310775	381
350	04122029251	382
68	04143156319	66
352	04141067121	384
353	04242704612	385
354	04122591148	386
355	04125996302	387
356	04141340188	388
357	04241999790	389
358	04168322971	390
359	04140435450	391
360	04242208549	392
361	04167180719	393
362	04126321511	394
363	04242203323	395
364	04129615125	396
365	04263352678	397
324	04143896650	356
366	04146301451	398
367	04141203262	399
368	04166228506	400
325	04141376424	358
369	04122025029	401
370	04143896650	402
371	04140235102	403
372	04140183158	404
373	04126177027	405
374	04146624164	406
375	04129713204	407
376	04122445302	408
377	04146797698	409
378	04129090958	410
379	04149050017	411
380	04121491404	412
381	04125394974	413
382	04125611527	414
383	04120106061	105
384	04141203262	138
385	04241737288	415
386	04143137402	416
387	04242116687	417
388	04165226348	418
389	04143206064	419
390	04149130474	420
391	04129090958	421
392	04241591890	422
393	04127217214	423
394	04120211818	424
395	04242389419	425
396	04262195874	426
397	04266395800	427
398	04129916316	428
399	04160145581	429
400	04242672841	430
401	04242067837	150
402	04129905522	431
403	04129847088	432
404	04127060418	433
405	04241857426	434
406	04241758417	435
407	04241814790	436
408	04129007303	437
409	04241297016	438
410	04242201042	439
411	04168108913	440
412	04269109635	441
413	04242560001	442
414	04142718398	443
415	04163037715	231
416	04241342159	444
417	04242129920	445
418	04242044927	446
419	04127250669	447
420	04241432837	448
421	04242353522	449
104	04263187686	102
422	04141516166	450
423	04241833332	451
424	04123771735	452
425	04241657639	453
426	04129909135	454
427	04120961550	455
428	04248560280	95
429	04269877076	456
430	04248839447	457
431	04261865302	458
432	04122550424	459
433	04123503795	460
434	04123595587	251
435	04166661449	4
436	04122618401	461
437	04149962323	462
438	04248094272	297
439	04164294066	90
440	04124740227	463
441	04121495683	13
442	04161959896	464
443	04148297507	465
444	04148297507	466
445	04162959944	467
446	04263897741	468
447	04120675979	208
448	04162953461	51
321	04123595587	108
449	04120867796	469
123	04165970491	121
450	04122920210	470
451	04123503795	471
452	04126874421	472
453	04123503795	473
322	04120104818	355
326	04120166365	359
327	04126106213	360
329	04129278484	363
\.


--
-- Name: c_p_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.c_p_id_seq', 1115, true);


--
-- Name: concurso_id_concurso_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.concurso_id_concurso_seq', 36, true);


--
-- Name: e_p_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.e_p_id_seq', 645, true);


--
-- Name: en_p_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.en_p_id_seq', 41, true);


--
-- Name: encuentro_id_encuentro_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.encuentro_id_encuentro_seq', 1, true);


--
-- Name: estado_id_estado_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.estado_id_estado_seq', 33, true);


--
-- Name: exposicion_id_expo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.exposicion_id_expo_seq', 49, true);


--
-- Name: obra_id_obra_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.obra_id_obra_seq', 1164, true);


--
-- Name: participante_id_participante_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.participante_id_participante_seq', 473, true);


--
-- Name: t_p_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.t_p_id_seq', 135, true);


--
-- Name: taller_id_taller_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.taller_id_taller_seq', 35, true);


--
-- Name: telefono_id_telefono_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.telefono_id_telefono_seq', 453, true);


--
-- Name: c_p c_p_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.c_p
    ADD CONSTRAINT c_p_pkey PRIMARY KEY (id);


--
-- Name: concurso concurso_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.concurso
    ADD CONSTRAINT concurso_pkey PRIMARY KEY (id_concurso);


--
-- Name: e_p e_p_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_p
    ADD CONSTRAINT e_p_pkey PRIMARY KEY (id);


--
-- Name: en_p en_p_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.en_p
    ADD CONSTRAINT en_p_pkey PRIMARY KEY (id);


--
-- Name: encuentro encuentro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encuentro
    ADD CONSTRAINT encuentro_pkey PRIMARY KEY (id_encuentro);


--
-- Name: estado estado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estado
    ADD CONSTRAINT estado_pkey PRIMARY KEY (id_estado);


--
-- Name: exposicion exposicion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exposicion
    ADD CONSTRAINT exposicion_pkey PRIMARY KEY (id_expo);


--
-- Name: obra obra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obra
    ADD CONSTRAINT obra_pkey PRIMARY KEY (id_obra);


--
-- Name: participante participante_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participante
    ADD CONSTRAINT participante_pkey PRIMARY KEY (id_participante);


--
-- Name: t_p t_p_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.t_p
    ADD CONSTRAINT t_p_pkey PRIMARY KEY (id);


--
-- Name: taller taller_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taller
    ADD CONSTRAINT taller_pkey PRIMARY KEY (id_taller);


--
-- Name: telefono telefono_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_pkey PRIMARY KEY (id_telefono);


--
-- Name: c_p c_p_concurso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.c_p
    ADD CONSTRAINT c_p_concurso_id_fkey FOREIGN KEY (concurso_id) REFERENCES public.concurso(id_concurso) ON DELETE CASCADE;


--
-- Name: c_p c_p_participante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.c_p
    ADD CONSTRAINT c_p_participante_id_fkey FOREIGN KEY (participante_id) REFERENCES public.participante(id_participante) ON DELETE CASCADE;


--
-- Name: e_p e_p_exposicion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_p
    ADD CONSTRAINT e_p_exposicion_id_fkey FOREIGN KEY (exposicion_id) REFERENCES public.exposicion(id_expo) ON DELETE CASCADE;


--
-- Name: e_p e_p_obra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_p
    ADD CONSTRAINT e_p_obra_id_fkey FOREIGN KEY (obra_id) REFERENCES public.obra(id_obra) ON DELETE SET NULL;


--
-- Name: e_p e_p_participante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.e_p
    ADD CONSTRAINT e_p_participante_id_fkey FOREIGN KEY (participante_id) REFERENCES public.participante(id_participante) ON DELETE CASCADE;


--
-- Name: en_p en_p_encuentro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.en_p
    ADD CONSTRAINT en_p_encuentro_id_fkey FOREIGN KEY (encuentro_id) REFERENCES public.encuentro(id_encuentro) ON DELETE CASCADE;


--
-- Name: en_p en_p_participante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.en_p
    ADD CONSTRAINT en_p_participante_id_fkey FOREIGN KEY (participante_id) REFERENCES public.participante(id_participante) ON DELETE CASCADE;


--
-- Name: obra obra_participante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obra
    ADD CONSTRAINT obra_participante_id_fkey FOREIGN KEY (participante_id) REFERENCES public.participante(id_participante) ON DELETE SET NULL;


--
-- Name: participante participante_estado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participante
    ADD CONSTRAINT participante_estado_id_fkey FOREIGN KEY (estado_id) REFERENCES public.estado(id_estado);


--
-- Name: t_p t_p_participante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.t_p
    ADD CONSTRAINT t_p_participante_id_fkey FOREIGN KEY (participante_id) REFERENCES public.participante(id_participante) ON DELETE CASCADE;


--
-- Name: t_p t_p_taller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.t_p
    ADD CONSTRAINT t_p_taller_id_fkey FOREIGN KEY (taller_id) REFERENCES public.taller(id_taller) ON DELETE CASCADE;


--
-- Name: telefono telefono_participante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_participante_id_fkey FOREIGN KEY (participante_id) REFERENCES public.participante(id_participante) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict GaKmVzq3z3ouJ9vTfKgChhxqR6plS1hhdIdjHltnSt4hvtOfMOytFRL7tEYKEoG

