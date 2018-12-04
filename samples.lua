-- ----------------------------------------------------------------------------
--
--  Samples - create a number of Unicode chars by blocks
--
-- (see List of Unicode characters - Wikipedia)
--
-- ----------------------------------------------------------------------------

local _format	= string.format
local _insert	= table.insert
local _concat	= table.concat

-- ----------------------------------------------------------------------------
--
local tUTF8Blocks =
{
	-- this very first entry has been modified
	-- for not printing garbage on display
	--
	{0x20, 0x7e},										-- Basic Latin

	{0xc2, 0xc3, 0x80, 0xbf},							-- Latin-1 Supplement
	{0xc4, 0xc5, 0x80, 0xbf},							-- Latin Extended-A
	{0xc6, 0xc8, 0x80, 0xbf},							-- Latin Extended-B
	{0xc9, 0xc9, 0x80, 0x8f},							-- Latin Extended-B (*)
	{0xc9, 0xc9, 0x90, 0xbf},							-- IPA Extensions
	{0xca, 0xca, 0x80, 0xaf},							-- IPA Extensions (*)
	{0xca, 0xca, 0xb0, 0xbf},							-- Spacing Modifier Letters
	{0xcb, 0xcb, 0x80, 0xbf},							-- Spacing Modifier Letters (*)
	{0xcc, 0xcc, 0x80, 0xbf},							-- Combining Diacritical Marks
	{0xcd, 0xcd, 0x80, 0xaf},							-- Combining Diacritical Marks (*)
	{0xcd, 0xcd, 0xb0, 0xbf},							-- Greek and Coptic
	{0xce, 0xcf, 0x80, 0xbf},							-- Greek and Coptic (*)
	{0xd0, 0xd3, 0x80, 0xbf},							-- Cyrillic
	{0xd4, 0xd4, 0x80, 0xaf},							-- Cyrillic Supplement
	{0xd4, 0xd4, 0xb0, 0xbf},							-- Armenian
	{0xd5, 0xd5, 0x80, 0xbf},							-- Armenian (*)
	{0xd6, 0xd6, 0x80, 0x8f},							-- Armenian (*)
	{0xd6, 0xd6, 0x90, 0xbf},							-- Hebrew
	{0xd7, 0xd7, 0x80, 0xbf},							-- Hebrew (*)
	{0xd8, 0xd8, 0x80, 0xbf},							-- Arabic
	{0xd9, 0xdb, 0x80, 0xbf},							-- Arabic (*)
	{0xdc, 0xdc, 0x80, 0xbf},							-- Syriac
	{0xdd, 0xdd, 0x80, 0x8f},							-- Syriac (*)
	{0xdd, 0xdd, 0x90, 0xbf},							-- Arabic Supplement
	{0xde, 0xde, 0x80, 0xbf},							-- Thaana
	{0xdf, 0xdf, 0x80, 0xbf},							-- NKo

	{0xe0, 0xe0, 0xa0, 0xa0, 0x80, 0xbf},				-- Samaritan	
	{0xe0, 0xe0, 0xa1, 0xa1, 0x80, 0x9f},				-- Mandaic
	{0xe0, 0xe0, 0xa1, 0xa1, 0xa0, 0xaf},				-- Syriac Supplement
	{0xe0, 0xe0, 0xa1, 0xa1, 0xb0, 0xbf},				-- No_Block
	{0xe0, 0xe0, 0xa2, 0xa2, 0x80, 0x9f},				-- No_Block
	{0xe0, 0xe0, 0xa2, 0xa3, 0xa0, 0xbf},				-- Arabic Extended-A
	{0xe0, 0xe0, 0xa4, 0xa5, 0x80, 0xbf},				-- Devanagari
	{0xe0, 0xe0, 0xa6, 0xa7, 0x80, 0xbf},				-- Bengali
	{0xe0, 0xe0, 0xa8, 0xa9, 0x80, 0xbf},				-- Gurmukhi
	{0xe0, 0xe0, 0xaa, 0xab, 0x80, 0xbf},				-- Gujarati
	{0xe0, 0xe0, 0xac, 0xad, 0x80, 0xbf},				-- Oriya
	{0xe0, 0xe0, 0xae, 0xaf, 0x80, 0xbf},				-- Tamil	
	{0xe0, 0xe0, 0xb0, 0xb1, 0x80, 0xbf},				-- Telugu
	{0xe0, 0xe0, 0xb2, 0xb3, 0x80, 0xbf},				-- Kannada
	{0xe0, 0xe0, 0xb4, 0xb5, 0x80, 0xbf},				-- Malayalam	
	{0xe0, 0xe0, 0xb6, 0xb7, 0x80, 0xbf},				-- Sinhala
	{0xe0, 0xe0, 0xb8, 0xb9, 0x80, 0xbf},				-- Thai
	{0xe0, 0xe0, 0xba, 0xbb, 0x80, 0xbf},				-- Lao	
	{0xe0, 0xe0, 0xbc, 0xbf, 0x80, 0xbf},				-- Tibetan
	{0xe1, 0xe1, 0x80, 0x81, 0x80, 0xbf},				-- Myanmar
	{0xe1, 0xe1, 0x82, 0x82, 0x80, 0x9f},				-- Myanmar (*)	
	{0xe1, 0xe1, 0x82, 0x82, 0xa0, 0xbf},				-- Georgian
	{0xe1, 0xe1, 0x83, 0x83, 0x80, 0xbf},				-- Georgian (*)
	{0xe1, 0xe1, 0x84, 0x87, 0x80, 0xbf},				-- Hangul Jamo
	{0xe1, 0xe1, 0x88, 0x8d, 0x80, 0xbf},				-- Ethiopic
	{0xe1, 0xe1, 0x8e, 0x8e, 0x80, 0x9f},				-- Ethiopic Supplement
	{0xe1, 0xe1, 0x8e, 0x8e, 0xa0, 0xbf},				-- Cherokee
	{0xe1, 0xe1, 0x8f, 0x8f, 0x80, 0xbf},				-- Cherokee (*)
	{0xe1, 0xe1, 0x90, 0x99, 0x80, 0xbf},				-- Unified Canadian Aboriginal Syllabics
	{0xe1, 0xe1, 0x9a, 0x9a, 0x80, 0x9f},				-- Ogham
	{0xe1, 0xe1, 0x9a, 0x9a, 0xa0, 0xbf},				-- Runic
	{0xe1, 0xe1, 0x9b, 0x9b, 0x80, 0xbf},				-- Runic (*)	
	{0xe1, 0xe1, 0x9c, 0x9c, 0x80, 0x9f},				-- Tagalog
	{0xe1, 0xe1, 0x9c, 0x9c, 0xa0, 0xbf},				-- Hanunoo	
	{0xe1, 0xe1, 0x9d, 0x9d, 0x80, 0x9f},				-- Buhid
	{0xe1, 0xe1, 0x9d, 0x9d, 0xa0, 0xbf},				-- Tagbanwa
	{0xe1, 0xe1, 0x9e, 0x9f, 0x80, 0xbf},				-- Khmer	
	{0xe1, 0xe1, 0xa0, 0xa1, 0x80, 0xbf},				-- Mongolian
	{0xe1, 0xe1, 0xa2, 0xa2, 0x80, 0xaf},				-- Mongolian (*)
	{0xe1, 0xe1, 0xa2, 0xa2, 0xb0, 0x9f},				-- Unified Canadian Aboriginal Syllabics Extended
	{0xe1, 0xe1, 0xa3, 0xa3, 0x80, 0xbf},				-- Unified Canadian Aboriginal Syllabics Extended (*)
	{0xe1, 0xe1, 0xa4, 0xa4, 0x80, 0xbf},				-- Limbu
	{0xe1, 0xe1, 0xa5, 0xa5, 0x80, 0x8f},				-- Limbu (*)
	{0xe1, 0xe1, 0xa5, 0xa5, 0x90, 0xbf},				-- Tai Le
	{0xe1, 0xe1, 0xa6, 0xa6, 0x80, 0xbf},				-- New Tai Lue
	{0xe1, 0xe1, 0xa7, 0xa7, 0x80, 0x9f},				-- New Tai Lue (*)
	{0xe1, 0xe1, 0xa7, 0xa7, 0xa0, 0xbf},				-- Khmer Symbols
	{0xe1, 0xe1, 0xa8, 0xa8, 0x80, 0x9f},				-- Buginese
	{0xe1, 0xe1, 0xa8, 0xa8, 0xa0, 0xbf},				-- Tai Tham
	{0xe1, 0xe1, 0xa9, 0xa9, 0x80, 0xbf},				-- Tai Tham (*)
	{0xe1, 0xe1, 0xaa, 0xaa, 0x80, 0xaf},				-- Tai Tham (*)	
	{0xe1, 0xe1, 0xaa, 0xaa, 0xb0, 0xbf},				-- Combining Diacritical Marks Extended
	{0xe1, 0xe1, 0xab, 0xab, 0x80, 0xbf},				-- Combining Diacritical Marks Extended (*)
	{0xe1, 0xe1, 0xac, 0xad, 0x80, 0xbf},				-- Balinese	
	{0xe1, 0xe1, 0xae, 0xae, 0x80, 0xbf},				-- Sundanese
	{0xe1, 0xe1, 0xaf, 0xaf, 0x80, 0xbf},				-- Batak
	{0xe1, 0xe1, 0xb0, 0xb0, 0x80, 0xbf},				-- Lepcha
	{0xe1, 0xe1, 0xb1, 0xb1, 0x80, 0x8f},				-- Lepcha (*)
	{0xe1, 0xe1, 0xb1, 0xb1, 0x90, 0xbf},				-- Ol Chiki	
	{0xe1, 0xe1, 0xb2, 0xb2, 0x80, 0x8f},				-- Cyrillic Extended-C
	{0xe1, 0xe1, 0xb2, 0xb2, 0x90, 0xbf},				-- Georgian Extended	
	{0xe1, 0xe1, 0xb3, 0xb3, 0x80, 0x8f},				-- Sundanese Supplement
	{0xe1, 0xe1, 0xb3, 0xb3, 0x90, 0xbf},				-- Vedic Extensions	
	{0xe1, 0xe1, 0xb4, 0xb5, 0x80, 0xbf},				-- Phonetic Extensions
	{0xe1, 0xe1, 0xb6, 0xb6, 0x80, 0xbf},				-- Phonetic Extensions Supplement
	{0xe1, 0xe1, 0xb7, 0xb7, 0x80, 0xbf},				-- Combining Diacritical Marks Supplement
	{0xe1, 0xe1, 0xb8, 0xbb, 0x80, 0xbf},				-- Latin Extended Additional
	{0xe1, 0xe1, 0xbc, 0xbf, 0x80, 0xbf},				-- Greek Extended
	{0xe2, 0xe2, 0x80, 0x80, 0x80, 0xbf},				-- General Punctuation
	{0xe2, 0xe2, 0x81, 0x81, 0x80, 0xaf},				-- General Punctuation (*)
	{0xe2, 0xe2, 0x81, 0x81, 0xb0, 0xbf},				-- Superscripts and Subscripts
	{0xe2, 0xe2, 0x82, 0x82, 0x80, 0x9f},				-- Superscripts and Subscripts (*)
	{0xe2, 0xe2, 0x82, 0x82, 0xa0, 0xbf},				-- Currency Symbols
	{0xe2, 0xe2, 0x83, 0x83, 0x80, 0x8f},				-- Currency Symbols (*)
	{0xe2, 0xe2, 0x83, 0x83, 0x90, 0xbf},				-- Combining Diacritical Marks for Symbols
	{0xe2, 0xe2, 0x84, 0x84, 0x80, 0xbf},				-- Letterlike Symbols
	{0xe2, 0xe2, 0x85, 0x85, 0x80, 0x8f},				-- Letterlike Symbols (contd)
	{0xe2, 0xe2, 0x85, 0x85, 0x90, 0xbf},				-- Number Forms
	{0xe2, 0xe2, 0x86, 0x86, 0x80, 0x8f},				-- Number Forms (contd)
	{0xe2, 0xe2, 0x86, 0x86, 0x90, 0xbf},				-- Arrows
	{0xe2, 0xe2, 0x87, 0x87, 0x80, 0xbf},				-- Arrows (contd)
	{0xe2, 0xe2, 0x88, 0x8b, 0x80, 0xbf},				-- Mathematical Operators
	{0xe2, 0xe2, 0x8c, 0x8f, 0x80, 0xbf},				-- Miscellaneous Technical
	{0xe2, 0xe2, 0x90, 0x90, 0x80, 0xbf},				-- Control Pictures	
	{0xe2, 0xe2, 0x91, 0x91, 0x80, 0x9f},				-- Optical Character Recognition
	{0xe2, 0xe2, 0x91, 0x91, 0xa0, 0xbf},				-- Enclosed Alphanumerics
	{0xe2, 0xe2, 0x92, 0x93, 0x80, 0xbf},				-- Enclosed Alphanumerics (contd)
	{0xe2, 0xe2, 0x94, 0x95, 0x80, 0xbf},				-- Box Drawing	
	{0xe2, 0xe2, 0x96, 0x96, 0x80, 0x9f},				-- Block Elements
	{0xe2, 0xe2, 0x96, 0x96, 0xa0, 0xbf},				-- Geometric Shapes
	{0xe2, 0xe2, 0x97, 0x97, 0x80, 0xbf},				-- Geometric Shapes (*)
	{0xe2, 0xe2, 0x98, 0x9b, 0x80, 0xbf},				-- Miscellaneous Symbols
	{0xe2, 0xe2, 0x9c, 0x9e, 0x80, 0xbf},				-- Dingbats
	{0xe2, 0xe2, 0x9f, 0x9f, 0x80, 0xaf},				-- Miscellaneous Mathematical Symbols-A
	{0xe2, 0xe2, 0x9f, 0x9f, 0xb0, 0xbf},				-- Supplemental Arrows-A	
	{0xe2, 0xe2, 0xa0, 0xa3, 0x80, 0xbf},				-- Braille Patterns
	{0xe2, 0xe2, 0xa4, 0xa5, 0x80, 0xbf},				-- Supplemental Arrows-B
	{0xe2, 0xe2, 0xa6, 0xa7, 0x80, 0xbf},				-- Miscellaneous Mathematical Symbols-B
	{0xe2, 0xe2, 0xa8, 0xab, 0x80, 0xbf},				-- Supplemental Mathematical Operators	
	{0xe2, 0xe2, 0xac, 0xaf, 0x80, 0xbf},				-- Miscellaneous Symbols and Arrows		
	{0xe2, 0xe2, 0xb0, 0xb0, 0x80, 0xbf},				-- Glagolitic
	{0xe2, 0xe2, 0xb1, 0xb1, 0x80, 0x9f},				-- Glagolitic (*)
	{0xe2, 0xe2, 0xb1, 0xb1, 0xa0, 0xbf},				-- Latin Extended-c
	{0xe2, 0xe2, 0xb2, 0xb3, 0x80, 0xbf},				-- Coptic
	{0xe2, 0xe2, 0xb4, 0xb4, 0x80, 0xaf},				-- Georgian Supplement
	{0xe2, 0xe2, 0xb4, 0xb4, 0xb0, 0xbf},				-- Tifinagh
	{0xe2, 0xe2, 0xb5, 0xb5, 0x80, 0xbf},				-- Tifinagh (*)
	{0xe2, 0xe2, 0xb6, 0xb6, 0x80, 0xbf},				-- Ethiopic Extended
	{0xe2, 0xe2, 0xb7, 0xb7, 0x80, 0x9f},				-- Ethiopic Extended (*)
	{0xe2, 0xe2, 0xb7, 0xb7, 0xa0, 0xbf},				-- Cyrillic Extended-A
	{0xe2, 0xe2, 0xb8, 0xb9, 0x80, 0xbf},				-- Supplemental Punctuation	
	{0xe2, 0xe2, 0xba, 0xbb, 0x80, 0xbf},				-- CJK Radicals Supplement
	{0xe2, 0xe2, 0xbc, 0xbe, 0x80, 0xbf},				-- Kangxi Radicals
	{0xe2, 0xe2, 0xbf, 0xbf, 0x80, 0xaf},				-- Kangxi Radicals (*)
	{0xe2, 0xe2, 0xbf, 0xbf, 0xb0, 0xbf},				-- Ideographic Description Characters
	{0xe3, 0xe3, 0x80, 0x80, 0x80, 0xbf},				-- CJK Symbols and Punctuation
	{0xe3, 0xe3, 0x81, 0x81, 0x80, 0xbf},				-- Hiragana
	{0xe3, 0xe3, 0x82, 0x82, 0x80, 0x9f},				-- Hiragana (*)
	{0xe3, 0xe3, 0x82, 0x82, 0xa0, 0xbf},				-- Katakana
	{0xe3, 0xe3, 0x83, 0x83, 0x80, 0xbf},				-- Katakana (*)
	{0xe3, 0xe3, 0x84, 0x84, 0x80, 0xaf},				-- Bopomofo
	{0xe3, 0xe3, 0x84, 0x84, 0xb0, 0xaf},				-- Hangul Compatibility Jamo
	{0xe3, 0xe3, 0x85, 0x85, 0x80, 0xbf},				-- Hangul Compatibility Jamo (*)
	{0xe3, 0xe3, 0x86, 0x86, 0x80, 0x8f},				-- Hangul Compatibility Jamo (*)
	{0xe3, 0xe3, 0x86, 0x86, 0x90, 0x9f},				-- Kanbun
	{0xe3, 0xe3, 0x86, 0x86, 0xa0, 0xbf},				-- Bopomofo Extended
	{0xe3, 0xe3, 0x87, 0x87, 0x80, 0xaf},				-- CJK Strokes	
	{0xe3, 0xe3, 0x87, 0x87, 0xb0, 0xbf},				-- Katakana Phonetic Extensions		
	{0xe3, 0xe3, 0x88, 0x8b, 0x80, 0xbf},				-- Enclosed CJK Letters and Months	
	{0xe3, 0xe3, 0x8c, 0x8f, 0x80, 0xbf},				-- CJK Compatibility
	{0xe3, 0xe3, 0x90, 0xbf, 0x80, 0xbf},				-- CJK Unified Ideographs Extension A
	{0xe4, 0xe4, 0x80, 0xb6, 0x80, 0xbf},				-- CJK Unified Ideographs Extension A (*)
	{0xe4, 0xe4, 0xb7, 0xb7, 0x80, 0xbf},				-- Yijing Hexagram Symbols
	{0xe4, 0xe4, 0xb8, 0xbf, 0x80, 0xbf},				-- CJK Unified Ideographs
	{0xe5, 0xe9, 0x80, 0xbf, 0x80, 0xbf},				-- CJK Unified Ideographs (*)
	{0xea, 0xea, 0x80, 0x91, 0x80, 0xbf},				-- Yi Syllables	
	{0xea, 0xea, 0x92, 0x92, 0x80, 0x8f},				-- Yi Syllables (*)
	{0xea, 0xea, 0x92, 0x92, 0x90, 0xbf},				-- Yi Radicals
	{0xea, 0xea, 0x93, 0x93, 0x80, 0x8f},				-- Yi Radicals (*)	
	{0xea, 0xea, 0x93, 0x93, 0x90, 0xbf},				-- Lisu
	{0xea, 0xea, 0x94, 0x98, 0x80, 0xbf},				-- Vai
	{0xea, 0xea, 0x99, 0x99, 0x80, 0xbf},				-- Cyrillic Extended-B
	{0xea, 0xea, 0x9a, 0x9a, 0x80, 0x9f},				-- Cyrillic Extended-B (*)
	{0xea, 0xea, 0x9a, 0x9a, 0xa0, 0xbf},				-- Bamum
	{0xea, 0xea, 0x9b, 0x9b, 0x80, 0xbf},				-- Bamum (*)	
	{0xea, 0xea, 0x9c, 0x9c, 0x80, 0x9f},				-- Modifier Tone Letters
	{0xea, 0xea, 0x9c, 0x9c, 0xa0, 0xbf},				-- Latin Extended-D
	{0xea, 0xea, 0x9d, 0x9f, 0x80, 0xbf},				-- Latin Extended-D (*)	
	{0xea, 0xea, 0xa0, 0xa0, 0x80, 0xaf},				-- Syloti Nagri
	{0xea, 0xea, 0xa0, 0xa0, 0xb0, 0xbf},				-- Common Indic Number Forms
	{0xea, 0xea, 0xa1, 0xa1, 0x80, 0xbf},				-- Phags-pa
	{0xea, 0xea, 0xa2, 0xa2, 0x80, 0xbf},				-- Saurashtra
	{0xea, 0xea, 0xa3, 0xa3, 0x80, 0x9f},				-- Saurashtra (*)
	{0xea, 0xea, 0xa3, 0xa3, 0xa0, 0xbf},				-- Devanagari Extended
	{0xea, 0xea, 0xa4, 0xa4, 0x80, 0xaf},				-- Kayah Li
	{0xea, 0xea, 0xa4, 0xa4, 0xb0, 0xbf},				-- Rejang
	{0xea, 0xea, 0xa5, 0xa5, 0x80, 0x9f},				-- Rejang (*)
	{0xea, 0xea, 0xa5, 0xa5, 0xa0, 0xbf},				-- Hangul Jamo Extended-A
	{0xea, 0xea, 0xa6, 0xa6, 0x80, 0xbf},				-- Javanese	
	{0xea, 0xea, 0xa7, 0xa7, 0x80, 0x9f},				-- Javanese (*)
	{0xea, 0xea, 0xa7, 0xa7, 0xa0, 0xbf},				-- Myanmar Extended-B
	{0xea, 0xea, 0xa8, 0xa8, 0x80, 0xbf},				-- Cham
	{0xea, 0xea, 0xa9, 0xa9, 0x80, 0x9f},				-- Cham (*)
	{0xea, 0xea, 0xa9, 0xa9, 0xa0, 0xbf},				-- Myanmar Extended-A
	{0xea, 0xea, 0xaa, 0xaa, 0x80, 0xbf},				-- Tai Viet
	{0xea, 0xea, 0xab, 0xab, 0x80, 0x9f},				-- Tai Viet (*)
	{0xea, 0xea, 0xab, 0xab, 0xa0, 0xbf},				-- Meetei Mayek Extensions
	{0xea, 0xea, 0xac, 0xac, 0x80, 0xaf},				-- Ethiopic Extended-A
	{0xea, 0xea, 0xac, 0xac, 0xb0, 0xbf},				-- Latin Extended-E
	{0xea, 0xea, 0xad, 0xad, 0x80, 0xaf},				-- Latin Extended-E (*)
	
	
	{0xea, 0xea, 0xad, 0xad, 0xb0, 0xbf},				-- ea ad ??
	{0xea, 0xea, 0xae, 0xbf, 0x80, 0xbf},				-- ea ae-bf ??
	{0xeb, 0xec, 0x80, 0xbf, 0x80, 0xbf},				-- CJK ??
	{0xed, 0xed, 0x80, 0x9f, 0x80, 0xbf},		-- *	-- CJK ??
	{0xee, 0xee, 0x80, 0xbf, 0x80, 0xbf},				-- ee 80-bf ??
	{0xef, 0xef, 0x80, 0xab, 0x80, 0xbf},				-- ef 80-ab ??	
	
	
	
	{0xef, 0xef, 0xac, 0xac, 0x80, 0xbf},				-- Alphabetic Presentation Forms
	{0xef, 0xef, 0xad, 0xad, 0x80, 0x8f},				-- Alphabetic Presentation Forms (*)	
	{0xef, 0xef, 0xad, 0xad, 0x90, 0xbf},				-- Arabic Presentation Forms-A	
	{0xef, 0xef, 0xae, 0xb7, 0x80, 0xbf},				-- Arabic Presentation Forms-A (*)
	{0xef, 0xef, 0xb8, 0xb8, 0x80, 0x8f},				-- Variation Selectors
	{0xef, 0xef, 0xb8, 0xb8, 0x90, 0x9f},				-- Vertical Forms
	{0xef, 0xef, 0xb8, 0xb8, 0xa0, 0xaf},				-- Combining Half Marks
	{0xef, 0xef, 0xb8, 0xb8, 0xb0, 0xbf},				-- ??
	{0xef, 0xef, 0xb9, 0xb9, 0x80, 0x8f},				-- ??
	{0xef, 0xef, 0xb9, 0xb9, 0x90, 0xaf},				-- Small Form Variants
	{0xef, 0xef, 0xb9, 0xb9, 0xb0, 0xbf},				-- ??	
	{0xef, 0xef, 0xba, 0xbb, 0x80, 0xbf},				-- ??		
	{0xef, 0xef, 0xbc, 0xbe, 0x80, 0xbf},				-- Halfwidth and Fullwidth Forms
	{0xef, 0xef, 0xbf, 0xbf, 0x80, 0xaf},				-- Halfwidth and Fullwidth Forms (*)
	{0xef, 0xef, 0xbf, 0xbf, 0xb0, 0xbf},				-- Specials
	
	
	{0xf0, 0xf0, 0x90, 0x90, 0x80, 0x81, 0x80, 0xbf},	-- Linear B Syllabary
	{0xf0, 0xf0, 0x90, 0x90, 0x82, 0x83, 0x80, 0xbf},	-- Linear B Ideograms		
	{0xf0, 0xf0, 0x90, 0x90, 0x84, 0x84, 0x80, 0xbf},	-- Aegean Numbers	
	{0xf0, 0xf0, 0x90, 0x90, 0x85, 0x85, 0x80, 0xbf},	-- Ancient Greek Numbers
	{0xf0, 0xf0, 0x90, 0x90, 0x86, 0x86, 0x80, 0x8f},	-- Ancient Greek Numbers (*)	
	{0xf0, 0xf0, 0x90, 0x90, 0x86, 0x86, 0x90, 0xbf},	-- Ancient Symbols
	{0xf0, 0xf0, 0x90, 0x90, 0x87, 0x87, 0x80, 0x8f},	-- Ancient Symbols (*)
	{0xf0, 0xf0, 0x90, 0x90, 0x87, 0x87, 0x90, 0xbf},	-- Phaistos Disc	
	{0xf0, 0xf0, 0x90, 0x90, 0x88, 0x88, 0x80, 0xbf},	-- f0 88 ??	
	{0xf0, 0xf0, 0x90, 0x90, 0x89, 0x89, 0x80, 0xbf},	-- f0 89 ??
	{0xf0, 0xf0, 0x90, 0x90, 0x8a, 0x8a, 0x80, 0x9f},	-- Lycian
	{0xf0, 0xf0, 0x90, 0x90, 0x8a, 0x8a, 0xa0, 0xbf},	-- Carian
	{0xf0, 0xf0, 0x90, 0x90, 0x8b, 0x8b, 0x80, 0x9f},	-- Carian (*)
	{0xf0, 0xf0, 0x90, 0x90, 0x8b, 0x8b, 0xa0, 0xbf},	-- f0 8b ??
	{0xf0, 0xf0, 0x90, 0x90, 0x8c, 0x8c, 0x80, 0xaf},	-- Old Italic
	{0xf0, 0xf0, 0x90, 0x90, 0x8c, 0x8c, 0xb0, 0xbf},	-- Gothic
	{0xf0, 0xf0, 0x90, 0x90, 0x8d, 0x8d, 0x80, 0x8f},	-- Gothic (*)
	{0xf0, 0xf0, 0x90, 0x90, 0x8d, 0x8d, 0x90, 0xbf},	-- Old Permic
	{0xf0, 0xf0, 0x90, 0x90, 0x8e, 0x8e, 0x80, 0x9f},	-- Ugaritic
	{0xf0, 0xf0, 0x90, 0x90, 0x8e, 0x8e, 0xa0, 0xbf},	-- Old Persian	
	{0xf0, 0xf0, 0x90, 0x90, 0x8f, 0x8f, 0x80, 0x9f},	-- Old Persian (*)	
	{0xf0, 0xf0, 0x90, 0x90, 0x8f, 0x8f, 0xa0, 0xbf},	-- f0 90 8f ??	
	{0xf0, 0xf0, 0x90, 0x90, 0x90, 0x90, 0x80, 0xbf},	-- Deseret
	{0xf0, 0xf0, 0x90, 0x90, 0x91, 0x91, 0x80, 0x8f},	-- Deseret (*)
	{0xf0, 0xf0, 0x90, 0x90, 0x91, 0x91, 0x90, 0xbf},	-- Shavian
	{0xf0, 0xf0, 0x90, 0x90, 0x92, 0x92, 0x80, 0xaf},	-- f0 92 ??	
	{0xf0, 0xf0, 0x90, 0x90, 0x92, 0x92, 0xb0, 0xbf},	-- Osage
	{0xf0, 0xf0, 0x90, 0x90, 0x93, 0x93, 0x80, 0xbf},	-- Osage (*)
	{0xf0, 0xf0, 0x90, 0x90, 0x94, 0x94, 0x80, 0xaf},	-- Elbasan
	{0xf0, 0xf0, 0x90, 0x90, 0x94, 0x94, 0xb0, 0xbf},	-- Caucasian Albanian
	{0xf0, 0xf0, 0x90, 0x90, 0x95, 0x95, 0x80, 0xaf},	-- Caucasian Albanian (*)
	{0xf0, 0xf0, 0x90, 0x90, 0x95, 0x95, 0xb0, 0xbf},	-- f0 95 ??
	{0xf0, 0xf0, 0x90, 0x90, 0x96, 0x97, 0x80, 0xbf},	-- f0 96-97 ??	
	{0xf0, 0xf0, 0x90, 0x90, 0x98, 0x9f, 0x80, 0xbf},	-- Linear A	
	{0xf0, 0xf0, 0x90, 0x90, 0xa0, 0xa0, 0x80, 0xbf},	-- Cypriot Syllabary
	{0xf0, 0xf0, 0x90, 0x90, 0xa1, 0xa1, 0x80, 0x9f},	-- f0 a1 ??	
	{0xf0, 0xf0, 0x90, 0x90, 0xa1, 0xa1, 0xa0, 0xbf},	-- Palmyrene
	{0xf0, 0xf0, 0x90, 0x90, 0xa2, 0xa3, 0x80, 0xbf},	-- f0 a2-a3 ??		
	{0xf0, 0xf0, 0x90, 0x90, 0xa4, 0xa4, 0x80, 0x9f},	-- Phoenician
	{0xf0, 0xf0, 0x90, 0x90, 0xa4, 0xa4, 0xa0, 0xbf},	-- Lydian
	{0xf0, 0xf0, 0x90, 0x90, 0xa5, 0xaf, 0x80, 0xbf},	-- f0 a5-af ??	
	{0xf0, 0xf0, 0x90, 0x90, 0xb0, 0xb0, 0x80, 0xbf},	-- Old Turkic
	{0xf0, 0xf0, 0x90, 0x90, 0xb1, 0xb1, 0x80, 0x8f},	-- Old Turkic (*)
	{0xf0, 0xf0, 0x90, 0x90, 0xb1, 0xb1, 0x90, 0xbf},	-- f0 b1 ??	
	{0xf0, 0xf0, 0x90, 0x90, 0xb2, 0xb3, 0x80, 0xbf},	-- Old Hungarian
	{0xf0, 0xf0, 0x90, 0x90, 0xb4, 0xbf, 0x80, 0xbf},	-- f0 90 b4-bf ??	
	{0xf0, 0xf0, 0x91, 0x91, 0x80, 0xa7, 0x80, 0xbf},	-- f0 91 80-a7 ??	
	{0xf0, 0xf0, 0x91, 0x91, 0xa8, 0xa8, 0x80, 0xbf},	-- Zanabazar Square
	{0xf0, 0xf0, 0x91, 0x91, 0xa9, 0xa9, 0x80, 0x8f},	-- Zanabazar Square (*)
	{0xf0, 0xf0, 0x91, 0x91, 0xa9, 0xa9, 0x90, 0xbf},	-- f0 91 a9 ??	
	{0xf0, 0xf0, 0x91, 0x91, 0xaa, 0xbf, 0x80, 0xbf},	-- f0 91 aa-bf ??	
	{0xf0, 0xf0, 0x92, 0x92, 0x80, 0x89, 0x80, 0xbf},	-- Cuneiform
	{0xf0, 0xf0, 0x92, 0x92, 0x90, 0x91, 0x80, 0xbf},	-- Cuneiform Numbers and Punctuation
	{0xf0, 0xf0, 0x92, 0x92, 0x92, 0x94, 0x80, 0xbf},	-- Early Dynastic Cuneiform
	{0xf0, 0xf0, 0x92, 0x92, 0x95, 0x95, 0x80, 0x8f},	-- Early Dynastic Cuneiform (*)	
	{0xf0, 0xf0, 0x92, 0x92, 0x95, 0x95, 0x90, 0xbf},	-- f0 92 95 ??
	{0xf0, 0xf0, 0x92, 0x92, 0x96, 0xbf, 0x80, 0xbf},	-- f0 92 96 bf ??	
	{0xf0, 0xf0, 0x93, 0x93, 0x80, 0x90, 0x80, 0xbf},	-- Egyptian Hieroglyphs		
	{0xf0, 0xf0, 0x93, 0x93, 0x91, 0xbf, 0x80, 0xbf},	-- f0 93 91 ??
	{0xf0, 0xf0, 0x94, 0x95, 0x80, 0xbf, 0x80, 0xbf},	-- f0 94-95 ??
	{0xf0, 0xf0, 0x96, 0x96, 0x80, 0xbe, 0x80, 0xbf},	-- f0 96 80 ??
	{0xf0, 0xf0, 0x96, 0x96, 0xbf, 0xbf, 0x80, 0x9f},	-- f0 96-bf ??
	{0xf0, 0xf0, 0x96, 0x96, 0xbf, 0xbf, 0xa0, 0xbf},	-- Ideographic Symbols and Punctuation
	{0xf0, 0xf0, 0x97, 0x9a, 0x80, 0xbf, 0x80, 0xbf},	-- f0 97-9a ??	
	{0xf0, 0xf0, 0x9b, 0x9b, 0x80, 0xaf, 0x80, 0xbf},	-- f0 9b 80 ??
	{0xf0, 0xf0, 0x9b, 0x9b, 0xb0, 0xb1, 0x80, 0xbf},	-- Duployan
	{0xf0, 0xf0, 0x9b, 0x9b, 0xb2, 0xb2, 0x80, 0x9f},	-- Duployan (*)
	{0xf0, 0xf0, 0x9b, 0x9b, 0xb2, 0xb2, 0xa0, 0xbf},	-- f0 9b b2 ??
	{0xf0, 0xf0, 0x9b, 0x9b, 0xb3, 0xbf, 0x80, 0xbf},	-- f0 9b  b3-bf
	{0xf0, 0xf0, 0x9c, 0x9c, 0x80, 0xbf, 0x80, 0xbf},	-- f0 9c ??
	{0xf0, 0xf0, 0x9d, 0x9d, 0x80, 0x83, 0x80, 0xbf},	-- f0 9d ??	
	{0xf0, 0xf0, 0x9d, 0x9d, 0x84, 0x87, 0x80, 0xbf},	-- Musical Symbols
	{0xf0, 0xf0, 0x9d, 0x9d, 0x88, 0x8c, 0x80, 0xbf},	-- f0 9d 88 ??
	{0xf0, 0xf0, 0x9d, 0x9d, 0x8d, 0x8d, 0x80, 0x9f},	-- f0 9d 8d ??
	{0xf0, 0xf0, 0x9d, 0x9d, 0x8d, 0x8d, 0xa0, 0xbf},	-- Counting Rod Numerals
	{0xf0, 0xf0, 0x9d, 0x9d, 0x8e, 0x8f, 0x80, 0xbf},	-- f0 9d 8e ??	
	{0xf0, 0xf0, 0x9d, 0x9d, 0x90, 0x9f, 0x80, 0xbf},	-- Mathematical Alphanumeric Symbols	
	{0xf0, 0xf0, 0x9d, 0x9d, 0xa0, 0xa9, 0x80, 0xbf},	-- Sutton SignWriting
	{0xf0, 0xf0, 0x9d, 0x9d, 0xaa, 0xaa, 0x80, 0xaf},	-- Sutton SignWriting (*)
	{0xf0, 0xf0, 0x9d, 0x9d, 0xaa, 0xaa, 0xb0, 0xbf},	-- f0 9d aa ??
	{0xf0, 0xf0, 0x9d, 0x9d, 0xab, 0xbf, 0x80, 0xbf},	-- f0 9d ab-bf ??	
	{0xf0, 0xf0, 0x9e, 0x9e, 0x80, 0xb7, 0x80, 0xbf},	-- f0 9e 80 ??
	{0xf0, 0xf0, 0x9e, 0x9e, 0xb8, 0xbb, 0x80, 0xbf},	-- Arabic Mathematical Alphabetic Symbols
	{0xf0, 0xf0, 0x9e, 0x9e, 0xbc, 0xbf, 0x80, 0xbf},	-- f0 9e bc ??
	{0xf0, 0xf0, 0x9f, 0x9f, 0x80, 0x80, 0x80, 0xaf},	-- Mahjong Tiles
	{0xf0, 0xf0, 0x9f, 0x9f, 0x80, 0x80, 0xb0, 0xbf},	-- Domino Tiles
	{0xf0, 0xf0, 0x9f, 0x9f, 0x81, 0x81, 0x80, 0xbf},	-- Domino Tiles (*)
	{0xf0, 0xf0, 0x9f, 0x9f, 0x82, 0x82, 0x80, 0x9f},	-- Domino Tiles (*)
	{0xf0, 0xf0, 0x9f, 0x9f, 0x82, 0x82, 0xa0, 0xbf},	-- Playing Cards
	{0xf0, 0xf0, 0x9f, 0x9f, 0x83, 0x83, 0x80, 0xbf},	-- Playing Cards (*)
	{0xf0, 0xf0, 0x9f, 0x9f, 0x84, 0x87, 0x80, 0xbf},	-- Enclosed Alphanumeric Supplement
	{0xf0, 0xf0, 0x9f, 0x9f, 0x88, 0x8b, 0x80, 0xbf},	-- Enclosed Ideographic Supplement
	{0xf0, 0xf0, 0x9f, 0x9f, 0x8c, 0x97, 0x80, 0xbf},	-- Miscellaneous Symbols and Pictographs	
	{0xf0, 0xf0, 0x9f, 0x9f, 0x98, 0x98, 0x80, 0xbf},	-- Emoticons
	{0xf0, 0xf0, 0x9f, 0x9f, 0x99, 0x99, 0x80, 0x8f},	-- Emoticons (*)	
	{0xf0, 0xf0, 0x9f, 0x9f, 0x99, 0x99, 0x90, 0xbf},	-- Ornamental Dingbats
	{0xf0, 0xf0, 0x9f, 0x9f, 0x9a, 0x9b, 0x80, 0xbf},	-- Transport and Map Symbols
	{0xf0, 0xf0, 0x9f, 0x9f, 0x9c, 0x9d, 0x80, 0xbf},	-- Alchemical Symbols
	{0xf0, 0xf0, 0x9f, 0x9f, 0x9e, 0x9f, 0x80, 0xbf},	-- Geometric Shapes Extended
	{0xf0, 0xf0, 0x9f, 0x9f, 0xa0, 0xa3, 0x80, 0xbf},	-- Supplemental Arrows-C		
	{0xf0, 0xf0, 0x9f, 0x9f, 0xa4, 0xa7, 0x80, 0xbf},	-- Supplemental Symbols and Pictographs
	{0xf0, 0xf0, 0x9f, 0x9f, 0xa8, 0xa8, 0x80, 0xbf},	-- Chess Symbols
	{0xf0, 0xf0, 0x9f, 0x9f, 0xa9, 0xa9, 0x80, 0xaf},	-- Chess Symbols (*)
	{0xf0, 0xf0, 0x9f, 0x9f, 0xa9, 0xa9, 0xb0, 0xbf},	-- No_Block
	{0xf0, 0xf0, 0x9f, 0x9f, 0xaa, 0xbf, 0x80, 0xbf},	-- No_Block
	{0xf0, 0xf0, 0xa0, 0xa9, 0x80, 0xbf, 0x80, 0xbf},	-- CJK Unified Ideographs Extension B
	{0xf0, 0xf0, 0xaa, 0xaa, 0x80, 0x9a, 0x80, 0xbf},	-- CJK Unified Ideographs Extension B (*)
	{0xf0, 0xf0, 0xaa, 0xaa, 0x9b, 0x9b, 0x80, 0x9f},	-- CJK Unified Ideographs Extension B (*)	
	{0xf0, 0xf0, 0xaa, 0xaa, 0x9b, 0x9b, 0xa0, 0xbf},	-- No_Block	
	{0xf0, 0xf0, 0xaa, 0xaa, 0x9c, 0xbf, 0x80, 0xbf},	-- CJK Unified Ideographs Extension C
	{0xf0, 0xf0, 0xab, 0xab, 0x80, 0x9c, 0x80, 0xbf},	-- CJK Unified Ideographs Extension C (*)
	{0xf0, 0xf0, 0xab, 0xab, 0x9d, 0x9f, 0x80, 0xbf},	-- CJK Unified Ideographs Extension D
	{0xf0, 0xf0, 0xab, 0xab, 0xa0, 0xa0, 0x80, 0x9f},	-- CJK Unified Ideographs Extension D (*)
	{0xf0, 0xf0, 0xab, 0xab, 0xa0, 0xa0, 0xa0, 0xbf},	-- CJK Unified Ideographs Extension E
	{0xf0, 0xf0, 0xab, 0xab, 0xa1, 0xbf, 0x80, 0xbf},	-- CJK Unified Ideographs Extension E (*)
	{0xf0, 0xf0, 0xac, 0xac, 0x80, 0xb9, 0x80, 0xbf},	-- CJK Unified Ideographs Extension E (*)
	{0xf0, 0xf0, 0xac, 0xac, 0xba, 0xba, 0x80, 0xaf},	-- CJK Unified Ideographs Extension E (*)
	{0xf0, 0xf0, 0xac, 0xac, 0xba, 0xba, 0xb0, 0xbf},	-- CJK Unified Ideographs Extension F
	{0xf0, 0xf0, 0xac, 0xac, 0xbb, 0xbf, 0x80, 0xbf},	-- CJK Unified Ideographs Extension F (*)
	{0xf0, 0xf0, 0xad, 0xad, 0x80, 0xbf, 0x80, 0xbf},	-- CJK Unified Ideographs Extension F (*)
	{0xf0, 0xf0, 0xae, 0xae, 0x80, 0xae, 0x80, 0xbf},	-- CJK Unified Ideographs Extension F (*)
	{0xf0, 0xf0, 0xae, 0xae, 0xaf, 0xaf, 0x80, 0xaf},	-- CJK Unified Ideographs Extension F (*)
	{0xf0, 0xf0, 0xae, 0xae, 0xaf, 0xaf, 0xb0, 0xbf},	-- No_Block
	{0xf0, 0xf0, 0xae, 0xae, 0xb0, 0xbf, 0x80, 0xbf},	-- No_Block
	{0xf0, 0xf0, 0xad, 0xae, 0x80, 0xbf, 0x80, 0xbf},	-- No_Block
	{0xf0, 0xf0, 0xaf, 0xaf, 0x80, 0x9f, 0x80, 0xbf},	-- No_Block
	{0xf0, 0xf0, 0xaf, 0xaf, 0xa0, 0xa7, 0x80, 0xbf},	-- CJK Compatibility Ideographs Supplement 	
	{0xf0, 0xf0, 0xaf, 0xaf, 0xa8, 0xa8, 0x80, 0x9f},	-- CJK Compatibility Ideographs Supplement (*)
	{0xf0, 0xf0, 0xaf, 0xaf, 0xa8, 0xa8, 0xa0, 0xbf},	-- No_Block
	{0xf0, 0xf0, 0xaf, 0xaf, 0xa9, 0xbf, 0x80, 0xbf},	-- No_Block
	{0xf0, 0xf0, 0xb0, 0xbf, 0x80, 0xbf, 0x80, 0xbf},	-- No_Block
	
	{0xf1, 0xf1, 0x80, 0xbf, 0x80, 0xbf, 0x80, 0xbf},	-- -> Private Area B <-
	
	{0xf2, 0xf2, 0x80, 0xbf, 0x80, 0xbf, 0x80, 0xbf},	-- -> Private Area C <-
	
	{0xf3, 0xf3, 0x80, 0x9f, 0x80, 0xbf, 0x80, 0xbf},	-- -> Private Area D <-
	{0xf3, 0xf3, 0xa0, 0xa0, 0x80, 0xbf, 0x80, 0xbf},	-- -> Unknown Extras <-
	{0xf3, 0xf3, 0xa1, 0xbf, 0x80, 0xbf, 0x80, 0xbf},	-- -> Private Area E <-
	
	{0xf4, 0xf4, 0x80, 0x8f, 0x80, 0xbf, 0x80, 0xbf},	-- * -- -> Private Area F <-
}


-- ----------------------------------------------------------------------------
--
local function CreateByBlock(inBlock, inLabel, inFilename, inMode, inAlignCols, inCompact)
	
	-- safety check
	--
	if 0 > inBlock or inBlock > #tUTF8Blocks then return false end
	
	-- open file
	--
	local fhTgt = io.open(inFilename, inMode)
	if not fhTgt then return false end
	
	-- check for the align column
	--
	inAlignCols = inAlignCols or 4
	if 4 > inAlignCols then inAlignCols = 4 end
		
	------------------
	-- By Block Number
	--
	local tUTFRow  = tUTF8Blocks[inBlock]		-- the interval's row
	local iRefUTF8 = 0							-- Unicode reference number U+...
	local iCurrCol = 0							-- counts columns for new line
	local tLineOut = { }						-- list of chars for current line
	local sCatChar = " "						-- char used for spacing chars
	local sHeader  = ""							-- header for a block
	local sLine    = ""							-- (helper just for clarity)
	local sAppend  = "\n"						-- how to terminate the file write
	local bSkipNL  = false						-- skip the first newline if (*)
	local sFormat1 = "%c"
	local sFormat2 = "%c%c"
	local sFormat3 = "%c%c%c"
	local sFormat4 = "%c%c%c%c"

	-- ------------------------------------
	-- this is the main header for a block
	--
	function _writeFileHeader(inText)
		
		inText = inText or "No Name Given"

		local tLines = { }
		local sUnderL = string.rep("-", math.max(40, #inText))

		_insert(tLines, "")
		_insert(tLines, sUnderL)
		_insert(tLines, inText)
		_insert(tLines, sUnderL)
		_insert(tLines, "")
		
		fhTgt:write(_concat(tLines, "\n"))
	end
	
	-- -----------------------
	--	write lines to file
	--
	function _flushLines()
		fhTgt:write(_concat(tLineOut, sCatChar))
		tLineOut = { }
		iCurrCol = 0
	end	
	
	-- -----------------------
	-- check if at the end
	--
	function _flushOnColumnBreak()
			
		iCurrCol = iCurrCol + 1
		if (0 == (iCurrCol % inAlignCols)) then
			_insert(tLineOut, "\n")
			_flushLines()
			
			iCurrCol = 0			-- check overflow
		end
	end
	
	-- -------------------------
	-- check if a new line is necessary
	-- if the block header text was written
	-- avoid thus an empty line
	-- (works reversed)
	--
	function _chkNewLine(inText)
		if not bSkipNL then return inText end
		
		-- done, this is the very first row
		-- remove the leading \n
		--
		bSkipNL = false
		return inText:sub(2)
	end
	
	-- write the row with the block header
	-- that is the U+ code and the mark bytes code
	--
	local function _addBlockHeader(inText)
		
		inText = _chkNewLine(inText)
		_insert(tLineOut, inText)
		_flushLines()		
	end
	
	-- -----------------------
	-- header line for the block
	--
	bSkipNL = inLabel:find("(*)", 1, true)
	if not bSkipNL then _writeFileHeader(inLabel, inBlock) end

	--------------------------------------
	-- the very first row is the std ascii
	--
	if not tUTFRow[3] then 
		_insert(tLineOut, "\n{U+0000}\n") 
		
		-- loop all codes
		--
		for iCurUTF=tUTFRow[1], tUTFRow[2] do
			
			sLine = _format(sFormat1, iCurUTF)
			_insert(tLineOut, sLine)
			_flushOnColumnBreak()
		end
		
		-- write and quit
		--
		_insert(tLineOut, sAppend)
		fhTgt:write(_concat(tLineOut, sCatChar))
		
		fhTgt:close()
	
		return true
	end
	
	--------------------------------------------
	-- loop all codes defined in row's intervals
	--
	for iCurUTF=tUTFRow[1], tUTFRow[2] do
		
		if not tUTFRow[5] then
			
			iRefUTF8 = ((iCurUTF - 0xc0) * 0x40) + (tUTFRow[3] - 0x80)
			
			sHeader = _format("\n{U+%04X} [0x%x]\n", iRefUTF8, iCurUTF)
			_addBlockHeader(sHeader)
		end
		
		for iByte1=tUTFRow[3], tUTFRow[4] do
			
			if tUTFRow[5] then
				
				if not tUTFRow[7] then
					
					iRefUTF8 = ((iCurUTF - 0xe0) * 0x1000) + ((iByte1 - 0x80) * 0x40) + (tUTFRow[5] - 0x80)
					
					sHeader = _format("\n{U+%04X} [0x%x 0x%x]\n", iRefUTF8, iCurUTF, iByte1)
					_addBlockHeader(sHeader)
				end
				
				for iByte2=tUTFRow[5], tUTFRow[6] do	
					
					if tUTFRow[7] then
						
						iRefUTF8 = ((iCurUTF - 0xf0) * 0x10000) + ((iByte1 - 0x80) * 0x1000) + ((iByte2 - 0x80) * 0x40) + (tUTFRow[7] - 0x80)
						
						sHeader = _format("\n{U+%06X} [0x%x 0x%x 0x%x]\n", iRefUTF8, iCurUTF, iByte1, iByte2)
						_addBlockHeader(sHeader)						
						
						for iByte3=tUTFRow[7], tUTFRow[8] do
							
							-- write interval of characters
							--
							if not inCompact then
								sLine = _format(sFormat4, iCurUTF, iByte1, iByte2, iByte3)	
								_insert(tLineOut, sLine)
								_flushOnColumnBreak()
							end
						end
					else
						
						-- write interval of characters
						--
						if not inCompact then
							sLine = _format(sFormat3, iCurUTF, iByte1, iByte2)
							_insert(tLineOut, sLine)
							_flushOnColumnBreak()
						end
					end
				end
				
				_flushLines()
			else
				
				-- write interval of characters
				--				
				if not inCompact then
					sLine = _format(sFormat2, iCurUTF, iByte1)
					_insert(tLineOut, sLine)
					_flushOnColumnBreak()
				end
			end
		end
		
		_flushLines()
	end

	-- terminate the write
	--
	fhTgt:write(sAppend)
	fhTgt:close()
	
	return true
end

-- ----------------------------------------------------------------------------
-- protect access to a table
--
local function protect(tbl)
	
	return setmetatable({ }, {
		__index		= tbl,
		__newindex 	= function(_, key, value)
			error("attempting to change constant " ..
				   tostring(key) .. " to " .. tostring(value), 2)
		end
	})
end

-- ----------------------------------------------------------------------------
--
local function Initialize()
	
	protect(tUTF8Blocks)
end

-- ----------------------------------------------------------------------------
--
return 
{
	Init 	= Initialize,
	ByBlock	= CreateByBlock,
}

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
