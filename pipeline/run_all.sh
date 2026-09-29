#!/bin/bash
# ============================================================
# LipoKG Analysis Pipeline - Master Run Script
# 脂蛋白代谢知识图谱分析流水线
# ============================================================
# 用法: bash scripts/run_all.sh [fig_number]
# 示例:
#   bash scripts/run_all.sh        # 运行全部
#   bash scripts/run_all.sh 1      # 只运行Fig 1
#   bash scripts/run_all.sh 2 3    # 运行Fig 2和Fig 3
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  LipoKG Analysis Pipeline                                ║"
echo "║  Lipoprotein Metabolism Knowledge Graph                  ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Project: $PROJECT_DIR"
echo "Python:  $(python3 --version 2>&1)"
echo "Date:    $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# ============================================================
# Fig运行函数
# ============================================================

run_fig1() {
    echo "═══════════════════════════════════════"
    echo "▶ Fig 1: Knowledge Graph Panorama"
    echo "═══════════════════════════════════════"
    python3 analysis/scripts/fig1/export_graph.py
}

run_fig2() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶ Fig 2: Knowledge Density & Mismatch"
    echo "═══════════════════════════════════════"
    python3 analysis/scripts/fig2/knowledge_density.py
}

run_fig3() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶ Fig 3: Temporal Evolution"
    echo "═══════════════════════════════════════"
    python3 analysis/scripts/fig3/temporal_evolution.py
}

run_fig4() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶ Fig 4: Knowledge Gap Discovery (ABC)"
    echo "═══════════════════════════════════════"
    python3 analysis/scripts/fig4/abc_model.py
}

run_fig5() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶ Fig 5: Cross-Validation Matrix"
    echo "═══════════════════════════════════════"
    python3 analysis/scripts/fig5/cross_validation.py
}

run_fig6() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶ Fig 6: Model Evaluation Framework"
    echo "═══════════════════════════════════════"
    python3 analysis/scripts/fig6/model_evaluation.py
}

run_fig7() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶ Fig 7: Case Study Deep Dive"
    echo "═══════════════════════════════════════"
    python3 analysis/scripts/fig7/case_study.py
}

# ============================================================
# 主逻辑
# ============================================================

if [ $# -eq 0 ]; then
    # 运行全部
    run_fig1
    run_fig2
    run_fig3
    run_fig4
    run_fig5
    run_fig6
    run_fig7
else
    # 运行指定Figure
    for fig in "$@"; do
        case $fig in
            1) run_fig1 ;;
            2) run_fig2 ;;
            3) run_fig3 ;;
            4) run_fig4 ;;
            5) run_fig5 ;;
            6) run_fig6 ;;
            7) run_fig7 ;;
            *) echo "❌ Unknown figure: $fig" ;;
        esac
    done
fi

# ============================================================
# 总结
# ============================================================

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  Pipeline Complete!                                      ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Output directories:"
for i in 1 2 3 4 5 6 7; do
    dir="analysis/output/fig$i"
    if [ -d "$dir" ]; then
        count=$(ls "$dir" 2>/dev/null | wc -l | tr -d ' ')
        echo "  📁 fig$i: $count files"
    fi
done
echo ""
echo "Next steps:"
echo "  1. Import cytoscape_graph.json into Cytoscape for Fig 1"
echo "  2. Integrate PKG data for Fig 2/3 paper counts"
echo "  3. Install PyTorch Geometric + PyKEEN for Fig 6"
echo "  4. Download GTEx v10 for Fig 2B expression data"
echo "  5. Download AlphaFold PDB for Fig 7B structure mapping"
