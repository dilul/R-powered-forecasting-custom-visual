"use strict";

import { formattingSettings } from "powerbi-visuals-utils-formattingmodel";

import FormattingSettingsCard = formattingSettings.SimpleCard;
import FormattingSettingsSlice = formattingSettings.Slice;
import FormattingSettingsModel = formattingSettings.Model;


/**
 * RCV Script Formatting Card
 */
class rcvScriptCardSettings extends FormattingSettingsCard {
    provider: FormattingSettingsSlice = undefined;
    source: FormattingSettingsSlice = undefined;

    name: string = "rcv_script";
    displayName: string = "rcv_script";
    slices: Array<FormattingSettingsSlice> = [this.provider, this.source];
}

/**
* visual settings model class
*
*/
export class VisualFormattingSettingsModel extends FormattingSettingsModel {
    // Create formatting settings model formatting cards
    rcvScriptCard = new rcvScriptCardSettings();

    cards = [this.rcvScriptCard];
}