%gain stage




ff = fopen("tabop-trans.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff,"Name & Value ($\\Omega$ or $S$)\\\\ \\midrule\n");
fprintf(ff,"$r_{\pi1}$ & %.5e \\\\\n", rpi1);
fprintf(ff,"$r_{o1}$ & %.5e \\\\\n", ro1);
fprintf(ff,"$g_{m1}$ & %.5e \\\\\n", gm1);
fprintf(ff,"$r_{\pi2}$ & %.5e \\\\\n", rpi2);
fprintf(ff,"$r_{o2}$ & %.5e \\\\\n", ro2);
fprintf(ff,"$g_{m2}$ & %.5e \\\\ \\bottomrule\n", gm2);
fprintf(ff,"\\end{tabular}");
fclose(ff);

ff = fopen("tabop.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff,"Name & Value (V or A)\\\\ \\midrule\n");
fprintf(ff,"@q1[ib] & %.5e \\\\\n", q1_ib);
fprintf(ff,"@q1[ie] & %.5e \\\\\n", q1_ie);
fprintf(ff,"@q1[ic] & %.5e \\\\\n", q1_ic);
fprintf(ff,"vb1 & %.5e \\\\\n", vb1);
fprintf(ff,"vc1 & %.5e \\\\\n", vc1);
fprintf(ff,"ve1 & %.5e \\\\\n", ve1);
fprintf(ff,"vbe1 & %.5e \\\\\n", vbe1);
fprintf(ff,"vce1 & %.5e \\\\\n", vce1);
fprintf(ff,"@q2[ib] & %.5e \\\\\n", q2_ib);
fprintf(ff,"@q2[ie] & %.5e \\\\\n", q2_ie);
fprintf(ff,"@q2[ic] & %.5e \\\\\n", q2_ic);
fprintf(ff,"vb2 & %.5e \\\\\n", vb2);
fprintf(ff,"vc2 & %.5e \\\\\n", vc2);
fprintf(ff,"ve2 & %.5e \\\\\n", ve2);
fprintf(ff,"veb2 & %.5e \\\\\n", veb2);
fprintf(ff,"vec2 & %.5e \\\\ \\bottomrule\n", vec2);
fprintf(ff,"\\end{tabular}");
fclose(ff);

ff = fopen("tabz.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff," & Value\\\\ \\midrule\n");
fprintf(ff,"$Z_{I_1}$ & %.5e \\\\\n", ZI1);
fprintf(ff,"$Z_{O_1}$ & %.5e \\\\\n", ZO1);
fprintf(ff,"$Z_{I_2}$ & %.5e \\\\\n", ZI2);
fprintf(ff,"$Z_{O_2}$ & %.5e \\\\\n", ZO2);
fprintf(ff,"$Z_{I_{total}}$ & %.5e \\\\\n", ZI);
fprintf(ff,"$Z_{O_{total}}$ & %.5e \\\\\n", ZO);
fprintf(ff,"$Gain_1$ & %6f \\\\\n", AV1);
fprintf(ff,"$Gain_2$ & %6f \\\\\n", AV2);
fprintf(ff,"$Gain_{total}$ & %6f \\\\\n", AV);
fprintf(ff,"$Gain_{total}\\ (dB)$ & %6f \\\\ \\bottomrule\n", AV_DB);
fprintf(ff,"\\end{tabular}");
fclose(ff);
  
ff = fopen("tabtotal.tex","w");
fprintf(ff,"$Z_{I_1}$ & %6f \\\\ \\hline\n", ZI1);
fprintf(ff,"$Z_{O_1}$ & %6f \\\\ \\hline\n", ZO1);
fprintf(ff,"$Z_{I_2}$ & %6f \\\\ \\hline\n", ZI2);
fprintf(ff,"$Z_{O_2}$ & %6f \\\\ \\hline\n", ZO2);
fprintf(ff,"$Z_{I_{total}}$ & %6f \\\\ \\hline\n", ZI);
fprintf(ff,"$Z_{O_{total}}$ & %6f \\\\ \\hline\n", ZO);
fprintf(ff,"$Gain_1$ & %6f \\\\ \\hline\n", AV1);
fprintf(ff,"$Gain_2$ & %6f \\\\ \\hline\n", AV2);
fprintf(ff,"$Gain_{total}$ & %6f \\\\ \\hline\n", AV);
fprintf(ff,"$Gain_{total}\\ (dB)$ & %6f \\\\ \\cline{2-2}\n", AV_DB);
fclose(ff);
