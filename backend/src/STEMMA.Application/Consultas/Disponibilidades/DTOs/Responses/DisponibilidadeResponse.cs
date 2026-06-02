using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace STEMMA.Application.Consultas.Disponibilidades.DTOs.Responses;

public class DisponibilidadeResponse
{
    public Guid Id { get; set; }

    public Guid VeterinarioId { get; set; }

    public DateTime DataInicio { get; set; }

    public DateTime DataFim { get; set; }
}