import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DataTableRow {
  final String id;
  final Map<String, String> cells;
  final VoidCallback onTap;
  final Color? statusColor;

  DataTableRow({
    required this.id,
    required this.cells,
    required this.onTap,
    this.statusColor,
  });
}

class CustomDataTable extends StatelessWidget {
  final List<String> columns;
  final List<DataTableRow> rows;
  final String title;
  final IconData titleIcon;
  final Color iconColor;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.title,
    required this.titleIcon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColors.gris.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  titleIcon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textoOscuro,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${rows.length} registros',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gris,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: AppColors.gris.withOpacity(0.05),
          child: Row(
            children: [
              for (String column in columns)
                Expanded(
                  child: Text(
                    column,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textoOscuro,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Table Rows
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.gris.withOpacity(0.1),
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (context, index) {
              final row = rows[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: row.onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        for (int i = 0; i < columns.length; i++)
                          Expanded(
                            child: _buildCell(
                              row.cells.values.elementAt(i),
                              i == 0, // Es la primera columna (ID)
                              row.statusColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String value, bool isId, Color? statusColor) {
    if (isId) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: iconColor,
          ),
        ),
      );
    }

    if (statusColor != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      );
    }

    return Text(
      value,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textoOscuro,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
