using STEMMA.Application.Consultas.Disponibilidades.DTOs.Responses;
using STEMMA.Application.Consultas.Disponibilidades.Mappers;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.Disponibilidades.UseCases;

public class ListDisponibilidadesPorVeterinarioUseCase
{
    private readonly IDisponibilidadeRepository _repository;

    public ListDisponibilidadesPorVeterinarioUseCase(
        IDisponibilidadeRepository repository)
    {
        _repository = repository;
    }

    public async Task<List<DisponibilidadeResponse>> ExecuteAsync(
        Guid veterinarioId)
    {
        var disponibilidades =
            await _repository.ObterPorVeterinarioAsync(
                veterinarioId);

        return DisponibilidadeMapper
            .ToResponseList(disponibilidades);
    }
}