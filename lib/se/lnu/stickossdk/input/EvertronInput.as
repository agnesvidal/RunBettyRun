﻿package se.lnu.stickossdk.input{	//-----------------------------------------------------------	// Public class	//-----------------------------------------------------------		/**	 *	Register över knappar som finns tillgängliga via 	 *	Evertrons knappstats (X-Arcade). Använd alltid denna 	 *	klass för att hantera tangentbordsinmatning, inga andra 	 *	tangenter får användas då de inte är tillgängliga via 	 *	arkadmaskinens knappstats.	 *	 *	@version	1.0	 *	@copyright	Copyright (c) 2012-2014.	 *	@license	Creative Commons (BY-NC-SA)	 *	@since		2013-01-22	 *	@author		Henrik Andersen <henrik.andersen@lnu.se>	 */	public class EvertronInput {				//-------------------------------------------------------		// Public static constants		//-------------------------------------------------------				/**		 *	UNIVERSAL CONTROLS		 * 		 *	Detta är knappsatsens flerfunktionsknappar.		 */		public static const UNIVERSAL_START_1:String	= 'NINE';		public static const UNIVERSAL_START_2:String	= 'ZERO';				/**		 *	PLAYER 1 CONTROLS		 * 		 *	Detta är kontrollerna för spelare ett.		 */		public static const PLAYER_1_UP:String			= 'W';		public static const PLAYER_1_LEFT:String		= 'A';		public static const PLAYER_1_DOWN:String		= 'S';		public static const PLAYER_1_RIGHT:String		= 'D';		public static const PLAYER_1_BUTTON_1:String	= 'ONE';		public static const PLAYER_1_BUTTON_2:String	= 'TWO';		public static const PLAYER_1_BUTTON_3:String	= 'THREE';		public static const PLAYER_1_BUTTON_4:String	= 'FOUR';		public static const PLAYER_1_BUTTON_5:String	= 'FIVE';		public static const PLAYER_1_BUTTON_6:String	= 'SIX';		public static const PLAYER_1_BUTTON_7:String	= 'SEVEN';		public static const PLAYER_1_BUTTON_8:String	= 'EIGHT';				/**		 *	PLAYER 2 CONTROLS		 * 		 *	Detta är kontrollerna för spelare två. 		 */		public static const PLAYER_2_UP:String			= 'UP';		public static const PLAYER_2_LEFT:String		= 'LEFT';		public static const PLAYER_2_DOWN:String		= 'DOWN';		public static const PLAYER_2_RIGHT:String		= 'RIGHT';		public static const PLAYER_2_BUTTON_1:String	= 'L'; // L		public static const PLAYER_2_BUTTON_2:String	= 'K'; // K		public static const PLAYER_2_BUTTON_3:String	= 'M';		public static const PLAYER_2_BUTTON_4:String	= 'N';		public static const PLAYER_2_BUTTON_5:String	= 'B';		public static const PLAYER_2_BUTTON_6:String	= 'V';		public static const PLAYER_2_BUTTON_7:String	= 'C';		public static const PLAYER_2_BUTTON_8:String	= 'X';	}}