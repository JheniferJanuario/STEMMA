using STEMMA.Application.Consultas.Disponibilidades.DTOs.Responses;
using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Application.Consultas.Disponibilidades.Mappers;

public static class DisponibilidadeMapper
{
    public static DisponibilidadeResponse ToResponse(
        Disponibilidade disponibilidade)
    {
        return new DisponibilidadeResponse
        {
            Id = disponibilidade.Id,
            VeterinarioId = disponibilidade.VeterinarioId,
            DataInicio = disponibilidade.DataInicio,
            DataFim = disponibilidade.DataFim
        };
    }

    public static List<DisponibilidadeResponse> ToResponseList(
        List<Disponibilidade> disponibilidades)
    {
        return disponibilidades
            .Select(ToResponse)
            .ToList();
    }
}